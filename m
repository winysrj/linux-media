Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:41726 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZD2XTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 19:19:45 -0400
Date: Wed, 29 Apr 2009 18:33:18 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: hermann pitton <hermann-pitton@arcor.de>
cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	Robin van Kleeff <robinvankleeff@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Digital compact cameras that can be used as video devices?
In-Reply-To: <1241039756.3710.78.camel@pc07.localdom.local>
Message-ID: <alpine.LNX.2.00.0904291650290.20872@banach.math.auburn.edu>
References: <a50ea2b0904291222p34e897e1qc2fb0f4ade337e6@mail.gmail.com>  <412bdbff0904291231p6eb9742dxb7e25c57ee83fa92@mail.gmail.com> <1241039756.3710.78.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Wed, 29 Apr 2009, hermann pitton wrote:

> Hi,
>
> Am Mittwoch, den 29.04.2009, 15:31 -0400 schrieb Devin Heitmueller:
>> On Wed, Apr 29, 2009 at 3:22 PM, Robin van Kleeff
>> <robinvankleeff@gmail.com> wrote:
>>> Hey everybody,
>>>
>>> I have been searching for information on using compact photo cameras
>>> as video devices (and also for compatibility with gphoto through the
>>> gphoto websites/mailing list).
>>>
>>> I was wondering if any of you knows which cameras (brand, type) I
>>> should focus on?  I'm interested in digital compact camera that can be
>>> used to take decent quality pictures, and also function as for
>>> instance a web cam for applications such as Ekiga.  I am unable to
>>> find any lists of cameras that are supported.
>>>
>>> By the way, I am much more an end-user then a developer, so forgive me
>>> if I ask dumb questions, or if I ask questions that are outside of the
>>> scope of this mailing list.
>>>
>>> Thanks in advance!
>>>
>>> Robin
>>
>> Hello Robin,
>>
>> Do you know of any such devices that claim to work like that even
>> under Windows?  Generally, all the digital cameras I see that can
>> capture video can't do it while the device is plugged in to the PC.
>> If you can provide some specific examples of models that do this under
>> Windows, we can possibly look at what would be required to make them
>> work under Linux.
>>
>> Cheers,
>>
>> Devin
>>
>
> never cared much about it, but I was the opposite opinion.
>
> If it has Composite or S-Video and audio out it should simply work I
> thought when plugged into the inputs of any capture card, also when
> switched into video mode.
>
> I tested it once on a cheapo Jenoptik 6.0z3 MPEG4 and don't remember any
> problems using an saa7131e Asus P7131 Dual with tvtime on Composite.
>
> In that case it is not registered as storage device at all.
>
> Cheers,
> Hermann

Ah. I was a little bit slow. Now I see what was behind the statement that

"Generally, all the digital cameras I see that can capture video can't do 
it while the device is plugged in to the PC."

So, for the original poster, here is (sort of) what is behind these 
comments:

1. Lots of still cameras, especially some of the really fancy ones are 
Mass Storage devices. To use a still camera which is a Mass Storage 
device, one merely mounts it just like any external hard drive, or flash 
drive. If a camera is a Mass Storage device, it can not be addressed in 
any other mode. In particular, it can not stream. It is acting then like a 
hard drive, and hard drives do not stream. Hard drives are for copying 
files onto and off of, that kind of thing.

2. There do exist cameras which can be addressed in more than one mode. It 
is not unusual to have a camera which can be addressed as a Mass Storage 
device and also in PTP mode. Sorry, about PTP mode I only know that it 
exists, is supported in Linux under libgphoto2, and some others are doing 
that.

3. If a camera will do more than one mode (Mass Storage or PTP, Mass 
Storage or streaming, PTP or streaming, or all three, in case such a thing 
exists) then its mode would have to be set before one plugs it into the 
computer, using some kind of control menu on the camera. Then, when the 
camera is plugged to the computer it will either come up with a different 
USB Product number (see my previous post) or will come up in some kind of 
different mode which is made explicit to the computer.

Incidentally, the way that a USB device tells the computer about such 
things is to answer a standard query as soon as it is hooked up. That 
standard query has certain fields for its response. The things which must 
be answered are such things as what the Vendor and Product numbers are, a 
revision number, whether or not the device supports any of the standard 
modes. For these, there are three-byte codes (for example, Class Mass 
Storage, Subclass Transparent SCSI, Protocol Bulk Transport is 0x08 0x06 
0x50), and the catchall classification is is 0xff 0xff 0xff meaning Class 
Proprietary, Subclass Proprietary, Protocol Proprietary. As I said, every 
USB device must provide this information in a standard way, and every 
operating system needs to have said information in order to know what to 
do in order to support the hardware which has just been plugged in. The 
way that you can see all of this information in human-readable form in 
Linux is to run the command lsusb, or to look at the file 
/proc/bus/usb/devices (not present on all distros). There is also some 
further explanation about such things in /usr/src/linux/Documentation/usb.

Sorry if the above is a digression, but it should explain to you what is 
going on, and in particular why a camera can not be simultaneously a 
streaming device and a mass storage device. Any given camera could in 
principle do both of these, but not at the same time. And it would be 
needed to set the camera up beforehand using the control features present 
on the camera itself, while it is not hooked to the computer, to run in 
one of those modes and not in the other when it is next hooked up.

Of course, a device which is Proprietary, Proprietary, Proprietary can 
jolly well do whatever it wants. The computer has been warned. The 
operating system either has the required support for the given device 
installed, or it does not. There are lots of proprietary dual-mode 
cameras. Some of them are supported and work very well in Linux. Some are 
not well supported or do not work at all. The reason for that is, of 
course, we get usually no cooperation at all from the hardware vendors.

For the reasons I described above, I suggested already that you should 
download the video4linux mcode, and probably also the libgphoto2 code. 
That way, you can search through the two source trees and look for matches 
and possibly come up with something which pleases you. Do understand that 
if you do this, though, you will be confined to cameras which are either 
PTP cameras or fully proprietary cameras. If a camera will act both as a 
Mass Storage camera and as a streaming device, then you will probably not 
catch it this way. Perhaps you can think of other ways to trap that 
information. So, sticking to just libgphoto2 and the kernel source, here 
is what I would try if I were you:

1. look at the list of cameras supported by the Gphoto project, at the 
project website, or run the gphoto2 --list-cameras command. See if you 
recognize any camera which looks interesting.

2. search the directory libgphoto2/camlibs for that camera, by name. For 
example, if you search for "Logitech Clicksmart 310" you will come up with 
a line, in libgphoto2/camlibs/clicksmart310/library.c which says

  {"Logitech Clicksmart 310", GP_DRIVER_STATUS_TESTING, 0x46d, 0x0900},

which tells you that the USB Vendor number is 0x46d and the Product number 
is 0x0900. Perhaps the vendor number should have been listed as 0x046d 
(oops!). So if you search somewhere else for 0x46d and what is written is 
0x046d instead you will come up with thin air. Be careful with things like 
that, also that you might need to search for 46D, as well.

Thus, if you search linux/drivers/media/video/gspca using (for example)

grep 0900 *

you will come up with

spca500.c:      {USB_DEVICE(0x046d, 0x0900), .driver_info = 
LogitechClickSmart310},

which informs you that the camera is supported both in libgphoto2 as a 
still camera and in the spca500 kernel driver for use in streaming mode.

I do use this camera only by way of example. Its max resolution is 
352x288, and probably you want a better camera. But you get the idea.

As another example, if you have a "Pixie Princess Jelly-Soft" camera, you 
can search on the Gphoto website, or run the command

gphoto2 --list-cameras and search the output for it, and find it. You will 
find a line which says

         {"Pixie Princess Jelly-Soft",    GP_DRIVER_STATUS_EXPERIMENTAL,
                                                         0x2770, 0x905c},

And then if you search for the Vendor number you will find in the gspca 
code

kilgota@khayyam:~/linux/gspca/gspca-repo/linux/drivers/media/video/gspca$ 
grep 2770 *
sq905.c:        {USB_DEVICE(0x2770, 0x9120)},
sq905c.c: * The 0x2770:0x9050 cameras have max resolution of 320x240.
sq905c.c:       {USB_DEVICE(0x2770, 0x905c)},
sq905c.c:       {USB_DEVICE(0x2770, 0x9050)},
sq905c.c:       {USB_DEVICE(0x2770, 0x913d)},
kilgota@khayyam:~/linux/gspca/gspca-repo/linux/drivers/media/video/gspca$

so you have one match in the file sq905c.c for the product number, too. 
The camera is not otherwise listed by name in the kernel source (because 
the driver for it supports at least sixteen other known cameras), but in 
spite of its funny name and appearance and squishy, pink "jelly-soft" 
exterior it is a quite standard SQ905C camera and works in streaming mode, 
too.

I hope this helps you find what you are looking for.

Theodore Kilgore
