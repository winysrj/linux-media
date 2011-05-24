Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:52997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab1EXHVN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 03:21:13 -0400
Message-ID: <4DDB5C6B.6000608@redhat.com>
Date: Tue, 24 May 2011 09:21:15 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105240850.35032.hverkuil@xs4all.nl>
In-Reply-To: <201105240850.35032.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 05/24/2011 08:50 AM, Hans Verkuil wrote:
> On Monday, May 23, 2011 22:17:06 Mauro Carvalho Chehab wrote:
>> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
>> during the weekend, I decided to add alsa support also on xawtv3, basically
>> to provide a real usecase example. Of course, for it to work, it needs the
>> very latest v4l2-utils version from the git tree.
>
> Please, please add at the very least some very big disclaimer in libv4l2util
> that the API/ABI is likely to change. As mentioned earlier, this library is
> undocumented, has not gone through any peer-review, and I am very unhappy with
> it and with the decision (without discussion it seems) to install it.
>

My I suggest that we instead just copy over the single get_media_devices.c
file to xawtv, and not install the not so much a lib lib ?

Mauro, I plan to do a new v4l-utils release soon (*), maybe even today. I
consider it unpolite to revert other peoples commits, so I would prefer for you
to revert the install libv4l2util.a patch yourself. But if you don't (or don't
get around to doing it before I do the release), I will revert it, as this
clearly needs more discussion before making it into an official release
tarbal (we can always re-introduce the patch after the release).

Regards,

Hans

*) To get a number of libv4l changes which I did recently out there.


> Once you install it on systems it becomes much harder to change.
>
> Regards,
>
> 	Hans
>
>> I've basically added there the code that Devin wrote for tvtime, with a few
>> small fixes and with the audio device auto-detection.
>>
>> With this patch, xawtv will now get the alsa device associated with a video
>> device node (if any), and start streaming from it, on a separate thread.
>>
>> As the code is the same as the one at tvtime, it should work at the
>> same devices that are supported there. I tested it only on two em28xx devices:
>> 	- HVR-950;
>> 	- WinTV USB-2.
>>
>> It worked with HVR-950, but it didn't work with WinTV USB-2. It seems that
>> snd-usb-audio do something different to set the framerate, that the alsa-stream
>> code doesn't recognize. While I didn't test, I think it probably won't work
>> with saa7134, as the code seems to hardcode the frame rate to 48 kHz, but
>> saa7134 supports only 32 kHz.
>>
>> It would be good to add an option to disable this behavior and to allow manually
>> select the alsa out device, so please send us patches ;)
>>
>> Anyway, patches fixing it and more tests are welcome.
>>
>> The git repositories for xawtv3 and v4l-utils is at:
>>
>> http://git.linuxtv.org/xawtv3.git
>> http://git.linuxtv.org/v4l-utils.git
>>
>> Thanks,
>> Mauro.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
