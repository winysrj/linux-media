Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab1FFHnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jun 2011 03:43:03 -0400
Message-ID: <4DEC851B.7030000@redhat.com>
Date: Mon, 06 Jun 2011 09:43:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: John McMaster <johndmcmaster@gmail.com>
CC: mchehab@redhat.com, linux-media@vger.kernel.org
Subject: Re: Anchor Chips V4L2 driver
References: <4DE873B4.4050306@gmail.com> <4DE8D065.7020502@redhat.com> <4DE8E018.7070007@redhat.com> <4DEC6862.8000006@gmail.com>
In-Reply-To: <4DEC6862.8000006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 06/06/2011 07:40 AM, John McMaster wrote:
> On 06/03/2011 06:22 AM, Hans de Goede wrote:
>> Hi,
>>
>> On 06/03/2011 02:15 PM, Mauro Carvalho Chehab wrote:
>>> Em 03-06-2011 02:40, John McMaster escreveu:
>>>> I'd like to write a driver for an Anchor Chips (seems to be bought by
>>>> Cypress) USB camera Linux driver sold as an AmScope MD1800.  It seems
>>>> like this implies I need to write a V4L2 driver.  The camera does not
>>>> seem its currently supported (checked on Fedora 13 / 2.6.34.8) and I
>>>> did
>>>> not find any information on it in mailing list archives.  Does anyone
>>>> know or can help me identify if a similar camera might already be
>>>> supported?
>>>
>>> I've no idea. Better to wait for a couple days for developers to
>>> manifest
>>> about that, if they're already working on it.
>>>
>>>> lsusb gives the following output:
>>>>
>>>> Bus 001 Device 111: ID 0547:4d88 Anchor Chips, Inc.
>>>>
>>>> I've started reading the "Video for Linux Two API Specification" which
>>>> seems like a good starting point and will move onto using source
>>>> code as
>>>> appropriate.  Any help would be appreciated.  Thanks!
>>>
>>> You'll find other useful information at linuxtv.org wiki page. The
>>> better
>>> is to write it as a sub-driver for gspca. The gspca core have already
>>> all
>>> that it is needed for cameras. So, you'll need to focus only at the
>>> device-specific
>>> stuff.
>>
>> I can second that you should definitely use gspca for usb webcam(ish)
>> device
>> drivers. As for how to go about this, first of all grep through the
>> windows drivers
>> for strings which may hint on the actual bridge chip used, chances are
>> good
>> there is an already supported bridge inside the camera.
>>
>> If not then make usb dumps, and start reverse engineering ...
>>
>> Usually it is enough to replay the windows init sequence to get the
>> device
>> to stream over either an bulk or iso endpoint, and then it is time to
>> figure out what that stream contains (jpeg, raw bayer, some custom
>> format ???)
>>
>> Regards,
>>
>> Hans
> Thanks for the response.  I replayed some packets (using libusb) and am
> able to get something resembling the desired image through its bulk
> endpoint.  So now I just need to figure out how to decode it better,
> options, etc.  I'll post back to the list once I get something
> moderately stable running and have taken a swing at the kernel driver.
>

Hmm, bulk you say and cypress and 8mp usb2.0 have you tried looking
at the gspca-ovfx2 driver? Likely you've an ovfx2 cam with an as of
yet unknown usb-id. Chances are just adding the id is enough, although
your sensor may be unknown.

Regards,

Hans
