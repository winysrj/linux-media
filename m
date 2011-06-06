Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39195 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1FFFkY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 01:40:24 -0400
Received: by pzk9 with SMTP id 9so1691758pzk.19
        for <linux-media@vger.kernel.org>; Sun, 05 Jun 2011 22:40:24 -0700 (PDT)
Message-ID: <4DEC6862.8000006@gmail.com>
Date: Sun, 05 Jun 2011 22:40:50 -0700
From: John McMaster <johndmcmaster@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>, mchehab@redhat.com
CC: linux-media@vger.kernel.org
Subject: Re: Anchor Chips V4L2 driver
References: <4DE873B4.4050306@gmail.com> <4DE8D065.7020502@redhat.com> <4DE8E018.7070007@redhat.com>
In-Reply-To: <4DE8E018.7070007@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 06/03/2011 06:22 AM, Hans de Goede wrote:
> Hi,
>
> On 06/03/2011 02:15 PM, Mauro Carvalho Chehab wrote:
>> Em 03-06-2011 02:40, John McMaster escreveu:
>>> I'd like to write a driver for an Anchor Chips (seems to be bought by
>>> Cypress) USB camera Linux driver sold as an AmScope MD1800.  It seems
>>> like this implies I need to write a V4L2 driver.  The camera does not
>>> seem its currently supported (checked on Fedora 13 / 2.6.34.8) and I
>>> did
>>> not find any information on it in mailing list archives.  Does anyone
>>> know or can help me identify if a similar camera might already be
>>> supported?
>>
>> I've no idea. Better to wait for a couple days for developers to
>> manifest
>> about that, if they're already working on it.
>>
>>> lsusb gives the following output:
>>>
>>> Bus 001 Device 111: ID 0547:4d88 Anchor Chips, Inc.
>>>
>>> I've started reading the "Video for Linux Two API Specification" which
>>> seems like a good starting point and will move onto using source
>>> code as
>>> appropriate.  Any help would be appreciated.  Thanks!
>>
>> You'll find other useful information at linuxtv.org wiki page. The
>> better
>> is to write it as a sub-driver for gspca. The gspca core have already
>> all
>> that it is needed for cameras. So, you'll need to focus only at the
>> device-specific
>> stuff.
>
> I can second that you should definitely use gspca for usb webcam(ish)
> device
> drivers. As for how to go about this, first of all grep through the
> windows drivers
> for strings which may hint on the actual bridge chip used, chances are
> good
> there is an already supported bridge inside the camera.
>
> If not then make usb dumps, and start reverse engineering ...
>
> Usually it is enough to replay the windows init sequence to get the
> device
> to stream over either an bulk or iso endpoint, and then it is time to
> figure out what that stream contains (jpeg, raw bayer, some custom
> format ???)
>
> Regards,
>
> Hans
Thanks for the response.  I replayed some packets (using libusb) and am
able to get something resembling the desired image through its bulk
endpoint.  So now I just need to figure out how to decode it better,
options, etc.  I'll post back to the list once I get something
moderately stable running and have taken a swing at the kernel driver.

John

