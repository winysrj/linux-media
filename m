Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:54359 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab1JUFT4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Oct 2011 01:19:56 -0400
Message-ID: <4EA100EF.9040800@freemail.hu>
Date: Fri, 21 Oct 2011 07:19:43 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Lars Noschinski <lars@public.noschinski.de>
CC: linux-media@vger.kernel.org
Subject: Re: pac7311
References: <20111017060334.GA16001@lars.home.noschinski.de> <4E9DDE13.103@freemail.hu> <20111020191837.GA14773@lars.home.noschinski.de>
In-Reply-To: <20111020191837.GA14773@lars.home.noschinski.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lars Noschinski wrote:
> * Németh Márton <nm127@freemail.hu> [11-10-18 22:14]:
>> Hi Lars,
>>
>> Lars Noschinski wrote:
>>> I'm using a webcam (Philipps SPC500NC) which identifies itself as
>>>
>>>     093a:2603 Pixart Imaging, Inc. PAC7312 Camera
>>>
>>> and is sort-of supported by the gspca_pac7311 module. "sort-of" because
>>> the image alternates quickly between having a red tint or a green tint
>>> (using the gspac driver from kernel 3.0.0, but this problem is present
>>> since at least 2.6.31).
>> The most important source code for your webcam is drivers/media/video/gspca/pac7311.c .
>> You can see it online at http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/media/video/gspca/pac7311.c .
>>
>>> If I remove and re-plugin the camera a few times (on average around 3
>>> times), the colors are stable.
>> When you plug and remove the webcam and the colors are wrong, do you get any
>> message in the "dmesg"?
> 
> I get the same messages; sometimes the order of the messages output by
> uhci_hcd ehci_hcd differs, but this seems to be unrelated to working/not
> working.
> 
>> Once the colors are stable and you unplug and replug the webcam, what happens then?
>> Is there again around 3 times when the webcam is not working properly?
> 
> I now did a longer series of unplug&replug: Over the time, status
> "stable colors" seemed to get more probable. After a while, it only
> falls back to alternating colors, when I unplug it for a longer time
> (say 10 seconds). Might be a hardware problem?

You might want to try the same webcam on different USB port to exclude the
connector problem on the computer. I don't know if you have the possibility
to try the webcam on a completly different computer also.

>>> Then a second issue becomes apparent:
>>> There is almost no saturation in the image. Toying around with Contrast,
>>> Gamma, Exposure or Gain does not help. What _does_ help is the Vflip
>>> switch: If I enable it, the image is flipped vertically (as expected),
>>> but also the color become a lot better.
>> Is there any difference when you use the "Mirror" control? What about the
>> combination of the "Vflip" and "Mirror" controls?
> 
> "Vflip" and ("Vflip" and "Mirror") change color; "Mirror" alone does
> not.
> 
>> What about the "Auto Gain" setting? Is it enabled or disabled in your case?
> 
> Auto Gain is enabled; but colors also change if it is disabled
>>> Is there something I can do to debug/fix this problem?
>> You can try testing the webcam with different resolutions. The webcam
>> supports 160x120, 320x240 and 640x480 resolutions based on the source code.
>> You can try the different resolutions for example with "cheese"
>> ( http://projects.gnome.org/cheese/ ) or any of your favorite V4L2 program.
> 
> This does not seem to make a difference; except that 160x120 is listed,
> but does not seem to be available. guvcview tells me:
> 
> Checking video mode 640x480@32bpp : OK 
> setting new resolution (320 x 240)
> checking format: 859981650
> Checking video mode 320x240@32bpp : OK 
> setting new resolution (160 x 120)
> checking format: 859981650
> Checking video mode 160x120@32bpp : OK 
> ioctl (-1067952623) retried 4 times - giving up: Die Ressource ist zur Zeit nicht verfügbar)
> VIDIOC_DQBUF - Unable to dequeue buffer : Die Ressource ist zur Zeit nicht verfügbar
> Error grabbing image 
> (the last message is then repeated, till i change the resolution)
> 
> [Also, since I switched to 160x120, cheese crashes with a segfault,
> without giving me the possibility to switch back and I cannot find the
> config file.]

You can try running cheese using the command line "strace -f cheese" to see what was the last
system call before the crash. If you have the debug symbols installed for cheese then you
can also try running "gdb cheese". Once you get the (gdb) prompt enter the command "run".
Switch to 160x120 resolution. When cheese crashes you should get (gdb) prompt again. Execute
"bt" (backtrace) and send the result.

>> You can load the usbmon kernel module and use Wireshark to log the USB communication
>> between your computer and the webcam starting with plug-in. You can compare
>> the communication when the webcam starts to work correctly with the one when
>> the webcam doesn't work as expected.
> 
> I'll try to do this later this week.
> 
> Greetings,
>   Lars Noschinski
> 
> 

