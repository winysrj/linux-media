Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38690 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2KIRDf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2012 12:03:35 -0500
Received: by mail-bk0-f46.google.com with SMTP id jk13so1744560bkc.19
        for <linux-media@vger.kernel.org>; Fri, 09 Nov 2012 09:03:34 -0800 (PST)
Message-ID: <509D2958.9080109@googlemail.com>
Date: Fri, 09 Nov 2012 18:03:36 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 00/23] em28xx: add support fur USB bulk transfers
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com> <20121028175752.447c39d5@redhat.com> <508EA1B8.3070304@googlemail.com> <20121029180348.7e7967aa@redhat.com> <508EF1CF.8090602@googlemail.com> <20121030010012.30e1d2de@redhat.com> <20121030020619.6e854f70@redhat.com> <50900BF6.1030502@googlemail.com> <509BF403.2080002@googlemail.com> <20121109160216.630ea18f@gaivota.chehab>
In-Reply-To: <20121109160216.630ea18f@gaivota.chehab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 09.11.2012 17:02, schrieb Mauro Carvalho Chehab:
> Em Thu, 08 Nov 2012 20:03:47 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Am 30.10.2012 19:18, schrieb Frank Schäfer:
>>> Am 30.10.2012 06:06, schrieb Mauro Carvalho Chehab:
>>>
>>> <snip>
>>>> Did a git bisect. The last patch where the bug doesn't occur is this 
>>>> changeset:
>>>> 	em28xx: add module parameter for selection of the preferred USB transfer type
>>>>
>>>> That means that this changeset broke it:
>>>>
>>>> 	em28xx: use common urb data copying function for vbi and non-vbi devices
>>> Ok, thanks.
>>> That means we are VERY close...
>>>
>>> I think this is the only change that could cause the trouble:
>>>> @@ -599,6 +491,7 @@ static inline int em28xx_urb_data_copy_vbi(struct em28xx *dev, struct urb *urb)
>>>>  			len = actual_length - 4;
>>>>  		} else if (p[0] == 0x22 && p[1] == 0x5a) {
>>>>  			/* start video */
>>>> +			dev->capture_type = 1;
>>>>  			p += 4;
>>>>  			len = actual_length - 4;
>>>>  		} else {
>>> Could you try again with this line commented out ? (em28xx-video.c, line
>>> 494 in the patched file).
>>> usb_debug=1 would be usefull, too.
>>>
>>>> I didn't test them with my Silvercrest webcam yet.
>>> I re-tested 5 minutes ago with this device and it works fine.
>>> Btw, which frame rates do you get  ? ;)
>>>
>>> Regards,
>>> Frank
>> Today I had the chance to test these patches with a Hauppauge HVR-930c.
>> Couldn't test analog TV (not supported yet), but DVB works fine, too.
> While I would love to have it, analog support for HVR-930C would likely
> not happen. I don't know anyone working on it. There are two issues there:
> 1) it uses an unsupported micronas analog demod chipset;
> 2) drx-k requrires some changes to tune on analog  mode.

Yeah, I heard about that. :(

> As usual, patches for it are of course very welcome.

I don't own this device, just borrowed it for some minutes for testing.
Apart from that, it seems I will be busy with the Laplace webcam support
for the next years... :D

Regards,
Frank

>
>> So patches 1 to 21 have been tested now and do at least not cause any
>> regressions.
>>
>> I would like to drop the last two patches (22+23) of this series, because
>> - they are actually not related to USB bulk transfers
>> - patch 22 needs to be fixed for analog+vbi (will get an analog device
>> for testing next week)
>> - I'm working on further improvements/changes in this area (including
>> em25xx support)
>> So I will better come up with a separate patch series later.
> OK.
>
>> Will send a v2 of this patch series soon.
>>
>> Regards,
>> Frank
>>
>>
> Cheers,
> Mauro

