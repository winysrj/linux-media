Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56839 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab0ERRNL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 13:13:11 -0400
Received: by gwaa20 with SMTP id a20so1262737gwa.19
        for <linux-media@vger.kernel.org>; Tue, 18 May 2010 10:13:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BEEC5E5.9020805@rogers.com>
References: <AANLkTilbPB2DeJhah0XzSMYEOpXUTzt-v4-h9JsV1BP2@mail.gmail.com>
	<4BEEC5E5.9020805@rogers.com>
From: Alexjan Carraturo <axjslack@gmail.com>
Date: Tue, 18 May 2010 19:12:50 +0200
Message-ID: <AANLkTilJ24ok_LzX_m3QvXz8tio0DIfarYp5Dj0hUc5o@mail.gmail.com>
Subject: Re: Pinnacle PCTV DVB-T 70e
To: CityK <cityk@rogers.com>
Cc: video4linux-list@redhat.com,
	Linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/5/15 CityK <cityk@rogers.com>:
> Hi Alex,
>
> this list is all but dead. Use the linux-media mailing list instead (I
> have cc'ed my reply to it).....in the olden days, the video4linux list
> was the correct one for analog devices, and linux-dvb for (surprise,
> surprise) dvb related discussion. Nowadays, they have both been
> superseded by the linux-media list.
>
>> Long time I try to run a particular type of device DVB-T, and sometimes I did.
>>
>> The device in question is a Usbstick Pinnacle PCTV DVB-T (70th); is
>> USB, running lsusb we have this
>>
>> eb1a:2870 eMPIA Technology, Inc. Pinnacle PCTV Stick
>>
>> As I said before, once I managed to get it working with both Fedora
>> and Slackware (the Linux distributions that I use routinely).
>>
>> Did not work with the drivers on the kernel (em28xx, em28xx-dvb); the
>> "traditional driver" try to recognize the device, but doesn't work.
>>
>> The device works only (and very well) with a version made by some
>> individuals, called em28xx-new. There is a version of these drivers,
>> compile manually, but it works only until kernel 2.6.31 (
>> http://launchpadlibrarian.net/35049921/em28xx-new.tar.gz )
>>
>
> He stopped supporting his driver and now only works on closed source
> software.
>


And I think this is the point in question. No longer working on this driver.


>> Searching the internet I saw that many users are trying to work this
>> board (very common).
>>
>> Is there a way to incorporate the changes mentioned in the official driver?
>>
>
> No.
>


Why not? Because nobody can cure this entry? Or why the driver is not
compatible with the version in the kernel now?

>> Or, you can suggest how they might be modified drivers indicated to
>> work with recent kernels (2.6.32, and soon 2.6.33 or later)?
>>
>
> The person in question, unfortunately and needlessly, came to an impasse
> with the v4l-dvb project. He later stopped developing his work. And no
> one here is much interested in touching his with a hundred and ten foot
> pole.
>
> You can, however, look to see if you can add support for your device to
> the existing v4l-dvb kernel driver. There are several developers that
> are knowledgeable of the em28xx driver, and whom may be able to help you
> in that regard, but you will have to gain there attention first.
>
>

I'm sorry, but even knowing a bit 'of the C programming language, I
have never written a driver, I'm not able, and I honestly do not even
capable.

You tell me to add support to the current driver, but I have no idea
how to do. It is also good to clarify that the driver on the kernel
vanulla charge in the presence of this card, but simply does not work,
and does not create deivce (/dev/dvb/).

So knowing that I'm not able to write the driver, I would say that
this device is definitely dead and buried ... in this case would be at
least that was not loaded em28xx module (the one in the kernel),
avoiding giving the illusion that the driver functions.

I do not know if you can, but should be added, if any, in a sort of blacklist.

-- 
########################################
Alexjan Carraturo
admin of
Free Software Users Group Italia
http://www.fsugitalia.org
Fedora Ambassador: Axjslack
openSUSE Ambassador: Axjslack
Free Software Foundation Europe Fellow 1623
Software Freedom International board member
########################################
