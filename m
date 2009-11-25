Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.meta.ua ([194.0.131.19]:40839 "EHLO webmail.meta.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759457AbZKYTAl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 14:00:41 -0500
Message-ID: <46842.95.132.81.101.1259175646.metamail@webmail.meta.ua>
In-Reply-To: <1258314943.3276.3.camel@pc07.localdom.local>
References: <1258292980.3235.14.camel@pc07.localdom.local>
    <58364.95.133.222.95.1258298152.metamail@webmail.meta.ua>
    <1258314943.3276.3.camel@pc07.localdom.local>
Date: Wed, 25 Nov 2009 21:00:46 +0200 (EEST)
Subject: Re: Tuner drivers
From: rulet1@meta.ua
To: "hermann pitton" <hermann-pitton@arcor.de>
Cc: rulet1@meta.ua, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=windows-1251
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>
> Am Sonntag, den 15.11.2009, 17:15 +0200 schrieb rulet1@meta.ua:
>> > Hi,
>> >
>> > Am Sonntag, den 15.11.2009, 14:42 +0200 schrieb rulet1@meta.ua:
>> >> How to do that?:
>> >>
>> >> "You are forced to use saa7134-alsa dma sound"
>> >>
>> >
>> > a problem is that I can't tell for sure which analog TV standard you
>> > currently use in the Ukraine, either it is still SECAM DK or you
>> changed
>> > to some PAL already.
>> >
>> > Try to get the details, also about the sound system.
>> >
>> > If it is still SECAM DK, you need to force the option "secam=DK".
>> >
>> > With "audio_debug=1" you can see if the drivers finds the pilots, the
>> > first sound carrier and the second carrier and also the stereo system
>> in
>> > use. This counts also for PAL standards.
>> >
>> > This way you can already see if the driver can lock on the audio
>> > carriers in "dmesg" without hearing anything yet.
>> >
>> > Then saa7134-alsa should provide TV sound on your card.
>> > http://linuxtv.org/wiki/index.php/Saa7134-alsa
>> >
>> > Cheers,
>> > Hermann
>> >
>> >
>> >
>> > Where to put the option "secam=DK" on Ubuntu 9.10?
>> >
>
> Don't have it, but would guess /etc/modprobe.d or use a
> deprecated /etc/modprobe.conf and "depmod -a" or close all mixers using
> saa7134, "modprobe -vr saa7134-alsa" and "modprobe saa7134 secam=DK".
>
> Hermann
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
Forget about it, this tuner is just not for Linux...

______________________________
Моя почта живет на Мете http://webmail.meta.ua

