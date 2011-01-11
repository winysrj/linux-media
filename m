Return-path: <mchehab@pedra>
Received: from ns.mm-sol.com ([213.240.235.226]:53750 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754144Ab1AKOAT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 09:00:19 -0500
Message-ID: <4D2C6200.3070805@mm-sol.com>
Date: Tue, 11 Jan 2011 15:58:24 +0200
From: Yordan Kamenov <ykamenov@mm-sol.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH 1/1] Add plugin support to libv4l
References: <cover.1294418213.git.ykamenov@mm-sol.com> <4aa83c66a0b9030d422123f49d75e6eb5e2d58bd.1294418213.git.ykamenov@mm-sol.com> <4D28B720.7050202@redhat.com>
In-Reply-To: <4D28B720.7050202@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for your comments.

Hans de Goede wrote:
> Hi,
>
> First of all many thanks for working on this! I've several remarks
> which I would like to see addressed before merging this.
>
> Since most remarks are rather high level remarks I've opted to
> just make a bulleted list of them rather then inserting them inline.
>
> * The biggest problem with your current implementation is that for
> each existing libv4l2_foo function you check if there is a plugin 
> attached
> to the fd passed in and if that plugin wants to handle the call. Now lets
> assume that there is a plugin and that it wants to handle all calls. That
> means that you've now effectively replaced all libv4l2_foo calls
> with calling the corresponding foo function from the plugin and returning
> its result. This means that for this fd / device you've achieved the
> same result as completely replacing libv4l2.so.0 with a new library
> containing the plugin code.
>
> IOW you've not placed then plugin between libv4l2 and the device (as
> intended) but completely short-circuited / replaced libv4l2. This means
> for example for a device which only supports yuv output, that libv4l2 
> will
> no longer do format emulation and conversion and an app which only 
> supports
> devices which deliver rgb data will no longer work.
>
> To actually place the plugin between libv4l2 (and libv4lconvert) and the
> device, you should replace all the SYS_FOO calls in libv4l2. The SYS_FOO
> calls are the calls to the actual device, so be replacing those with 
> calls
> to the plugin you actual place the plugin between libv4l and the 
> device as
> intended.
I agree with that, currently the plugin can replace the libv4l2, but if
we replace SYS_FOO calls it will actually sit between library and the
video node. I will do that.
>
> * Currently you add a loop much like the one in the v4l2_get_index
> function to each libv4l2_plugin function. Basically you add an array of
> v4l2_plugin_info structs in libv4l2-plugin. Which gets searched by fd,
> much like the v4l2_dev_info struct array. Including needing similar
> locking. I would like you to instead just store the plugin info for
> a certain fd directly into the v4l2_dev_info struct. This way the
> separate array, looping and locking can go away.
I have put separate array, because the array of v4l2_dev_info is declared
static in libv4l2.c and is not visible to v4l2-plugin.c (I did't want to
change it's declaration). But with changes that you suggest below, there
is no problem to add plugin data to v4l2_dev_info.
>
> * Next I would also like to see all the libv4l2_plugin_foo functions
> except for libv4l2_plugin_open go away. Instead libv4l2.c can call
> the plugin functions directly. Let me try to explain what I have in
> mind. Lets say we store the struct libv4l2_plugin_data pointer to the
> active plugin in the v4l2_dev_info struct and name it dev_ops
> (short for device operations).
>
> Then we can replace all SYS_FOO calls inside libv4l2 (except the ones
> were v4l2_get_index returns -1), with a call to the relevant devop
> functions, for example:
>                 result = SYS_IOCTL(devices[index].fd, VIDIOC_REQBUFS, 
> req);
> Would become:
>                 result = devices[index].dev_ops->v4l2_plugin_ioctl(
>                                     devices[index].fd, VIDIOC_REQBUFS, 
> req);
>
> Note that the plugin_used parameter of the v4l2_plugin_ioctl is gone,
> it should simply do a normal SYS_IOCTL and return the return value
> of that if it is not interested in intercepting the ioctl (you could move
> the definition of the SYS_FOO macros to libv4l2-plugin.h to make them
> availables to plugins).
>
> Also I think it would be better to rename the function pointers inside
> the libv4l2_plugin_data struct from v4l2_plugin_foo to just foo, so
> that the above code would become:
>                 result = devices[index].dev_ops->v4l2_plugin_ioctl(
>                                     devices[index].fd, VIDIOC_REQBUFS, 
> req);
>
> * The above means that need to always have a dev_ops pointer, so we
> need to have a default_dev_ops struct to use when no plugin wants to
> talk to the device.
Ok, I will replace SYS_FOO calls with dev_ops structure.
>
> * You've put the v4l2_plugin_foo functions (of which only
> v4l2_plugin_foo will remain in my vision) in lib/include/libv4l2.h
> I don't think these functions should be public, their prototypes should
> be moved to lib/libv4l2/libv4l2-priv.h, and they should not be declared
> LIBV4L_PUBLIC.
>
> * There is one special case in all this, files under libv4lconvert also
> use SYS_IOCTL in various places. Since this now need to go through the
> plugin we need to take some special measures here. There are 2 options:
> 1) Break the libv4lconvert ABI (very few programs use it) and pass a
>    struct libv4l2_plugin_data pointer to the v4lconvert_create function.
>    *And* export the default_dev_ops struct from libv4l2.
> 2) Add a libv4l2_raw_ioctl method, which just gets the index and then
>    does devices[index].dev_ops->v4l2_plugin_ioctl
>    Except that this is not really an option as libv4lconvert should not
>    depend on libv4l2
> My vote personally goes to 1.
>
> * I think that once we do 1) from above it would be good to rename
> libv4l2_plugin_data to libv4l2_dev_ops, as that makes the public API
> more clear and dev_ops is in essence what a plugin provides.
>
> * Note that were I wrote: "like to see all the libv4l2_plugin_foo
> functions except for libv4l2_plugin_open go away" I did so for
> simplicity, in reality the wrappers around mmap and munmap need to
> stay too, but they should use data directly stored inside the
> v4l2_dev_info struct. This means that we need to either:
> mv the mmap and munmap code to libv4l2.c; or export the v4l2_dev_info
> struct array. I vote for exporting the v4l2_dev_info struct array
> (through libv4l2-priv.h, so it won't be visible to the outside
> world, but it will be usable outside libv4l2.c).
Ok, I will make 1) and export v4l2_dev_info.
>
> Thanks & Regards,
>
> Hans
>
Best Regards
Yordan

