Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54891 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1FMCDd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 22:03:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1106121554090.13986@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org>
	<4DF3324E.3050506@redhat.com>
	<alpine.LNX.2.00.1106111058170.12801@banach.math.auburn.edu>
	<4DF4A662.5090705@redhat.com>
	<alpine.LNX.2.00.1106121554090.13986@banach.math.auburn.edu>
Date: Mon, 13 Jun 2011 10:03:32 +0800
Message-ID: <BANLkTimDGMyvq_8r77a_aRGTKdQ6U6nPeg@mail.gmail.com>
Subject: Re: Improving kernel -> userspace (usbfs) usb device hand off
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 13, 2011 at 5:20 AM, Theodore Kilgore
<kilgota@banach.math.auburn.edu> wrote:
> On Sun, 12 Jun 2011, Hans de Goede wrote:
>> Actually libusb and libgphoto have been using the rebind orginal driver
>> functionality of the code for quite a while now,
>
> Oh? I can see that libusb is doing that, and I can also see that there is
> a "public" function for _unbinding_ a kernel driver, namely
>
> int usb_detach_kernel_driver_np()
>
> found in usb.h
>
> and it is used in libgphoto, as well.
>
> I am not sure that there is any corresponding rebind function which is
> public. Is it perhaps
>
> int usb_get_driver_np()
>
> ???
>
> By context (looking at libgphoto2-port/usb/libusb.c) I would think that
> this function is not the rebind function, but is only checking whether or
> not there is any potential conflict with a kernel driver. If I am right,
> then where is the publicly exported rebind function, and where does it
> currently get used in libgphoto2?

http://gphoto.svn.sourceforge.net/viewvc/gphoto/trunk/libgphoto2/libgphoto2_port/usb/libusb.c?revision=13652&view=markup

The rebind happened under the function "static int gp_port_usb_close
(GPPort *port)".
Since libgphoto2 is still using libusb-0.1, the unbind is using usbfs IOCTL
directly (USBDEVFS_CONNECT).

> So frankly after my eagerness yesterday I do not see how it can easily be
> made to work, after all.
>
>> unfortunately this
>> does not solve the problem, unless we somehow move to 1 central
>> coordinator for the device the user experience will stay subpar.

Now I understand what Hans is saying. It will be a lot of work trying
to sort out this issue in userspace. What can be the single central
coordinator? A device manager applet listing the program or service
which hold the device?

>> Example, user downloads pictures from the camera using shotwell,
>> gthumb, fspot or whatever, keeps the app in question open and the app
>> in question keeps the gphoto2 device handle open.
>>
>> User wants to do some skyping with video chat, skype complains it
>> cannot find the device, since the kernel driver currently is unbound.
>>
>> -> Poor user experience.
>
> Poor user experience, or merely poor user? The user ought to know better.
> Of course, I do agree that there are lots of such people, and it is a good
> idea to try to put up warning signs.

It is difficult to call the users "poor users" in this case. Since they may
not know that the other open program is holding the device. Some
warning message may help, not "I can not find the device" though. It
would be better to pinpoint which program is holding the device
and then ask the user to close that program. I understand this is
easily said than done...

Similar experiences for Windows about the serial port, sometimes
it is difficult for the user to know that some program or service
are holding the serial port so that the other program or will fail or
Windows complain that it is still open when you want to undock
the computer.

>>
>> With having both functions in the kernel, the kernel could actually
>> allow skype to use the dual mode cameras as video source, and if
>> the user then were to switch to f-spot and try to import more photo's
>> then he will get an -ebusy in f-spot. If he finishes skyping and
>> then returns to f-spot everything will just continue working.
>>
>> This is the kind of "seamless" user experience I'm aiming for here.
>>
> Yes, I can see where you are coming from. But if the camera really will
> not let you run skype and fspot at the same time, which I do not believe
> it would allow on _any_ operating system, then each app should give an
> error message which says it cannot be run unless and until the other app
> has been closed. If that has to happen at the kernel level, then OK.
>

Yes. From what I read, to solve it in kernel or to solve it in user space
are both a lot of work.

Personally I tend to think to solve it in user space is more feasible.

-- 
Xiaofan
