Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:55333 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZHETwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 15:52:05 -0400
Received: by ywh13 with SMTP id 13so452825ywh.15
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 12:52:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A79E07F.1000301@iol.it>
References: <4A6F8AA5.3040900@iol.it> <4A729117.6010001@iol.it>
	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
	 <4A739DD6.8030504@iol.it>
	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>
	 <4A79320B.7090401@iol.it>
	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
	 <4A79CEBD.1050909@iol.it>
	 <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
	 <4A79E07F.1000301@iol.it>
Date: Wed, 5 Aug 2009 15:52:05 -0400
Message-ID: <829197380908051252i7899adacr5750c3b4157a7b86@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 3:41 PM, Valerio Messina<efa@iol.it> wrote:
> Devin Heitmueller ha scritto:
>>
>> Try running this:
>>
>> find /lib/modules/ -name "em28*"
>>
>> Then pastebin the output and send us a link.
>
> efa@01ath3200:~$ find /lib/modules/ -name "em28*"
> /lib/modules/2.6.24-21-generic/empia/em28xx-audioep.ko
> /lib/modules/2.6.24-21-generic/empia/em28xx-dvb.ko
> /lib/modules/2.6.24-21-generic/empia/em28xx-cx25843.ko
> /lib/modules/2.6.24-21-generic/empia/em28xx.ko
> /lib/modules/2.6.24-21-generic/empia/em28xx-audio.ko
> /lib/modules/2.6.24-21-generic/empia/em28xx-aad.ko
> /lib/modules/2.6.27-14-generic/empia/em28xx-audioep.ko
> /lib/modules/2.6.27-14-generic/empia/em28xx-dvb.ko
> /lib/modules/2.6.27-14-generic/empia/em28xx-cx25843.ko
> /lib/modules/2.6.27-14-generic/empia/em28xx.ko
> /lib/modules/2.6.27-14-generic/empia/em28xx-audio.ko
> /lib/modules/2.6.27-14-generic/empia/em28xx-aad.ko
> /lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx
> /lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> /lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
> /lib/modules/2.6.27-14-generic/kernel/drivers/media/video/em28xx/em28xx.ko
> /lib/modules/2.6.28-14-generic/empia/em28xx-audioep.ko
> /lib/modules/2.6.28-14-generic/empia/em28xx-dvb.ko
> /lib/modules/2.6.28-14-generic/empia/em28xx-cx25843.ko
> /lib/modules/2.6.28-14-generic/empia/em28xx.ko
> /lib/modules/2.6.28-14-generic/empia/em28xx-audio.ko
> /lib/modules/2.6.28-14-generic/empia/em28xx-aad.ko
> /lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx
> /lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> /lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
> /lib/modules/2.6.28-14-generic/kernel/drivers/media/video/em28xx/em28xx.ko
> /lib/modules/2.6.28-13-generic/kernel/drivers/media/video/em28xx
> /lib/modules/2.6.27-9-generic/empia/em28xx-audioep.ko
> /lib/modules/2.6.27-9-generic/empia/em28xx-dvb.ko
> /lib/modules/2.6.27-9-generic/empia/em28xx-cx25843.ko
> /lib/modules/2.6.27-9-generic/empia/em28xx.ko
> /lib/modules/2.6.27-9-generic/empia/em28xx-audio.ko
> /lib/modules/2.6.27-9-generic/empia/em28xx-aad.ko
> /lib/modules/2.6.27-11-generic/empia/em28xx-audioep.ko
> /lib/modules/2.6.27-11-generic/empia/em28xx-dvb.ko
> /lib/modules/2.6.27-11-generic/empia/em28xx-cx25843.ko
> /lib/modules/2.6.27-11-generic/empia/em28xx.ko
> /lib/modules/2.6.27-11-generic/empia/em28xx-audio.ko
> /lib/modules/2.6.27-11-generic/empia/em28xx-aad.ko
>
> there's all the history of modules I compiled for past kernels, and that I
> keep installed
>
>> Also send us the output of:
>>
>> uname -a
>
> efa@01ath3200:~$ uname -a
> Linux 01ath3200 2.6.28-14-generic #47-Ubuntu SMP Sat Jul 25 00:28:35 UTC
> 2009 i686 GNU/Linux
>
> the last stable from Ubuntu 9.04
>
> Valerio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Note: I meant to say "/lib/modules/2.6.28-14-generic/empia" instead of
just /lib/modules/2.6.28-14-generic.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
