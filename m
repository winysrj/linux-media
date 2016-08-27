Return-path: <linux-media-owner@vger.kernel.org>
Received: from meg8.auburn.edu ([131.204.2.75]:35118 "EHLO meg8.auburn.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752002AbcH0Vuy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Aug 2016 17:50:54 -0400
Date: Sat, 27 Aug 2016 18:06:50 -0500
From: Theodore Kilgore <kilgota@auburn.edu>
To: Randy Li <randy.li@rock-chips.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
        <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>,
        "ayaka@soulik.info" <ayaka@soulik.info>
Subject: Re: Plan to support Rockchip VPU in DRM, is it a good idea
In-Reply-To: <c0aadac7-b16d-dc5d-41b0-d5aaac528ef0@rock-chips.com>
Message-ID: <alpine.LNX.2.20.1608271719100.11798@khayyam.home.com>
References: <a56a7da9-154b-c889-67f6-81bd7e4c7a7d@rock-chips.com> <526b56fc-004b-a25d-e370-3e5c03d8e2f0@xs4all.nl> <c0aadac7-b16d-dc5d-41b0-d5aaac528ef0@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Fri, 26 Aug 2016, Randy Li wrote:

>
>
> On 08/26/2016 05:34 PM, Hans Verkuil wrote:
>> Hi Randi,
>> 
>> On 08/26/2016 04:13 AM, Randy Li wrote:
>>> Hello,
>>>    We always use some kind of hack work to make our Video Process
>>> Unit(Multi-format Video Encoder/Decoder) work in kernel. From a
>>> customize driver(vpu service) to the customize V4L2 driver. The V4L2
>>> subsystem is really not suitable for the stateless Video process or it
>>> could make driver too fat.
>>>    After talking to some kindness Intel guys and moving our userspace
>>> library to VA-API driver, I find the DRM may the good choice for us.
>>> But I don't know whether it is welcome to to submit a video driver in
>>> DRM subsystem?
>>>    Also our VPU(Video process unit) is not just like the Intel's, we
>>> don't have VCS, we based on registers to set the encoder/decoder. I
>>> think we may need a lots of IOCTL then. Also we do have a IOMMU in VPU
>>> but also not a isolated memory for VPU, I don't know I should use TT
>>> memory or GEM memory.
>>>    I am actually not a member of the department in charge of VPU, and I
>>> am just beginning to learning DRM(thank the help from Intel again), I am
>>> not so good at memory part as well(I am more familiar with CMA not the
>>> IOMMU way), I may need know guide about the implementations when I am
>>> going to submit driver, I hope I could get help from someone.
>>> 
>> 
>> It makes no sense to do this in the DRM subsystem IMHO. There are already
>> quite a few HW codecs implemented in the V4L2 subsystem and more are in the
>> pipeline. Putting codec support in different subsystems will just make
>> userspace software much harder to write.
>> 
>> One of the codecs that was posted to linux-media was actually from 
>> Rockchip:
>> 
>> https://lkml.org/lkml/2016/2/29/861
>> 
>> There is also a libVA driver (I think) that sits on top of it:
>> 
>> https://github.com/rockchip-linux/rockchip-va-driver/tree/v4l2-libvpu
> It is old version, I am the author of this
> https://github.com/rockchip-linux/rockchip-va-driver
>> 
>> For the Allwinner a patch series was posted yesterday:
>> 
>> https://lkml.org/lkml/2016/8/25/246
>> 
>> They created a pretty generic libVA userspace that looks very promising at
>> first glance.
>> 
>> What these have in common is that they depend on the Request API and Frame 
>> API,
>> neither of which has been merged. The problem is that the Request API 
>> requires
>> more work since not only controls have to be part of a request, but also 
>> formats,
>> selection rectangles, and even dynamic routing changes. While that is not 
>> relevant
>> for codecs, it is relevant for Android CameraHAL in general and complex 
>> devices
>> like Google's Project Ara.
> Actually just as the Intel did, our hardware decoder/encoder need full 
> settings for them, most of them are relevant to the codec. You may notice 
> that there is four extra control need to be set before. If the libvpu(a 
> helper library we offered to parse each slice to generate decoder settings) 
> is remove(in process now, only three decoder settings can't got from VA-API 
> directly), it would be more clearly.
> We really a lots decoder settings information to make the decoder work.
>> 
>> This is being worked on, but it is simply not yet ready. The core V4L2 
>> developers
>> involved in this plan to discuss this on the Monday before the ELCE in 
>> Berlin,
>> to see if we can fast track this work somehow so this support can be 
>> merged.
>> 
> I am glad to hear that. I hope that I could have an opportunity to show our 
> problems.
>> If there are missing features in V4L2 (other that the two APIs discussed 
>> above)
>> that prevent you from creating a good driver, then please discuss that with 
>> us.
>> We are always open to suggestions and improvements and want to work with 
>> you on
>> that.
> I have a few experience with the s5p-mfc, and I do wrote a V4L2 encoder 
> plugin for Gstreamer.  I don't think the V4L2 is good place for us stateless 
> video processor, unless it would break the present implementation.
>
>  The stateful and stateless are operated quite differently. The stateless 
> must parse the header and set those settings for every frames.

Then one needs to incorporate in the driver a way to detect whether one 
has to support "stateless" or "stateful." There must be a way to do this 
kind of thing, even if it is not documented by anybody. One way, perhaps, 
might be to look at the data and see if there is any header, or not. Then 
parse the header if it is present, otherwise don't.

> The request data may quite different from vendor to vendor, even chip to 
> chip.

By "request data" and "chip to chip" I assume you mean the initialization 
of a video chip, or something analogous or similar. Believe it or not, 
this kind of problem has been seen before and dealt with. Look at 
drivers/media/usb/gspca/mr97310a.c for an example. The exact problem that 
we faced was that different cameras had the same USB controller chip (and 
therefore shared a USB vendor:product code), but they had different sensor 
chips with different initialization sequences. The camera vendors merely 
slipped a Windows driver CD into each package, and sometimes they grabbed 
the wrong CD, too. Evidence of that was that Google used to give a lot of 
links to complaints about needing a functioning Windows driver for certain 
cheap cameras. Unless things have changed, the Linux driver for these 
cameras is the only one in existence for any operating system which will 
tell these cameras apart and send the right initialization sequence. 
Moreover, the method for detecting the chipset was completely undocumented 
by the manufacturers, who did not even acknowledge requests for 
information.

It is impossible to make a common way to send those settings to 
> driver.For the samsung MFC, you don't need to do any parse work at all.

Then, as I said, you need to write driver code which will know one of them 
from another. Surely you can do this.

Even though I continue to subscribe to the linux-media list and read with 
interest much of what I receive, I have not written much code for several 
years. I have two excuses. First, I am 75 years old now. Second, I have a 
full-time job doing something else.

But you work for a chip vendor. Thus on the one hand you and your company 
are certainly deserving of praise for troubling yourselves to communicate 
with Linux kernel developers at all. There are those who do not (see above 
for an example). But on the other hand you are dealing with very 
experienced people, who have written a lot of code and have done a lot of 
plannihg about what should go where in what is now a huge mass of kernel 
code, and who are rightly concerned that this code should be accessible 
and maintainable by someone else when they are gone from the scene.

I am not one of the main developers here, so perhaps you will be more 
willing to take it from me if I say that you and your company need to take 
seriously what those main developers are telling you. They have their 
reasons, and their reasons are very good reasons.

Theodore Kilgore

>  Anyway, I would like to follow what Intel does now, we are both stateless 
> video processor.
>> 
>> Regards,
>>
>> 	Hans
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>> 
>
> -- 
> Randy Li
> The third produce department
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
