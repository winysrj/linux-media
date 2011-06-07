Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64383 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab1FGFYX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 01:24:23 -0400
Received: by iyb14 with SMTP id 14so3708476iyb.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 22:24:22 -0700 (PDT)
Message-ID: <4DEDB623.2010200@gmail.com>
Date: Mon, 06 Jun 2011 22:24:51 -0700
From: John McMaster <johndmcmaster@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Anchor Chips V4L2 driver
References: <4DE873B4.4050306@gmail.com> <4DE8D065.7020502@redhat.com> <4DE8E018.7070007@redhat.com> <4DEC6862.8000006@gmail.com> <4DEC851B.7030000@redhat.com>
In-Reply-To: <4DEC851B.7030000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/06/2011 12:43 AM, Hans de Goede wrote:
> Hi,
>
> On 06/06/2011 07:40 AM, John McMaster wrote:
>> On 06/03/2011 06:22 AM, Hans de Goede wrote:
>>> Hi,
>>>
>>> On 06/03/2011 02:15 PM, Mauro Carvalho Chehab wrote:
>>>> Em 03-06-2011 02:40, John McMaster escreveu:
>>>>> I'd like to write a driver for an Anchor Chips (seems to be bought by
>>>>> Cypress) USB camera Linux driver sold as an AmScope MD1800.  It seems
>>>>> like this implies I need to write a V4L2 driver.  The camera does not
>>>>> seem its currently supported (checked on Fedora 13 / 2.6.34.8) and I
>>>>> did
>>>>> not find any information on it in mailing list archives.  Does anyone
>>>>> know or can help me identify if a similar camera might already be
>>>>> supported?
>>>>
>>>> I've no idea. Better to wait for a couple days for developers to
>>>> manifest
>>>> about that, if they're already working on it.
>>>>
>>>>> lsusb gives the following output:
>>>>>
>>>>> Bus 001 Device 111: ID 0547:4d88 Anchor Chips, Inc.
>>>>>
>>>>> I've started reading the "Video for Linux Two API Specification"
>>>>> which
>>>>> seems like a good starting point and will move onto using source
>>>>> code as
>>>>> appropriate.  Any help would be appreciated.  Thanks!
>>>>
>>>> You'll find other useful information at linuxtv.org wiki page. The
>>>> better
>>>> is to write it as a sub-driver for gspca. The gspca core have already
>>>> all
>>>> that it is needed for cameras. So, you'll need to focus only at the
>>>> device-specific
>>>> stuff.
>>>
>>> I can second that you should definitely use gspca for usb webcam(ish)
>>> device
>>> drivers. As for how to go about this, first of all grep through the
>>> windows drivers
>>> for strings which may hint on the actual bridge chip used, chances are
>>> good
>>> there is an already supported bridge inside the camera.
>>>
>>> If not then make usb dumps, and start reverse engineering ...
>>>
>>> Usually it is enough to replay the windows init sequence to get the
>>> device
>>> to stream over either an bulk or iso endpoint, and then it is time to
>>> figure out what that stream contains (jpeg, raw bayer, some custom
>>> format ???)
>>>
>>> Regards,
>>>
>>> Hans
>> Thanks for the response.  I replayed some packets (using libusb) and am
>> able to get something resembling the desired image through its bulk
>> endpoint.  So now I just need to figure out how to decode it better,
>> options, etc.  I'll post back to the list once I get something
>> moderately stable running and have taken a swing at the kernel driver.
>>
>
> Hmm, bulk you say and cypress and 8mp usb2.0 have you tried looking
> at the gspca-ovfx2 driver? Likely you've an ovfx2 cam with an as of
> yet unknown usb-id. Chances are just adding the id is enough, although
> your sensor may be unknown.
>
> Regards,
>
> Hans
If it helps, I should have also mentioned that with a small amount of
digging I found that the camera unit is put together by ScopeTek.  My
reference WIP implementation is at
https://github.com/JohnDMcMaster/uvscopetek which I'm comparing to
2.6.39.1 drivers.

Anyway, looking at reg_w() I see that it likes to make 0x00, 0x02, or
0x0A requests where as mine makes 0x01, 0x0A, and mostly 0x0B requests. 
I do see that it tends to want a byte back though like mine (0x0A except
at end).  My code has a few 3 byte returns (byte 0 varies, byte 1 fixed
at 0x00, byte 2 fixed at 0x08 like others), so I'm not sure if its a
good match for reg read.  Following that I tried to grep around some
more for a number of the more interesting numbers (eg: 90D8 as opposed
to 0001) in the $SRC/drivers/media/video dir and could only find
scattered matches.  I do realize that a lot of the more esoteric numbers
could be specific settings and not registers, commands, etc.  Or maybe
tofx2 is related and I'm not understanding the bridge concept?

John

