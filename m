Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35802 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaLPAJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 19:09:56 -0500
Received: by mail-lb0-f182.google.com with SMTP id f15so11008424lbj.27
        for <linux-media@vger.kernel.org>; Mon, 15 Dec 2014 16:09:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEzPJ9NqYNo2BV0j2jujVO+p3w73qxZOoM3K8J+yebFMVwwhWQ@mail.gmail.com>
References: <CAEzPJ9M=uOY_ujbp7XtrRq3N4jq6L3r_84qggfbQ4xEpX12u-w@mail.gmail.com>
	<CAEzPJ9NqYNo2BV0j2jujVO+p3w73qxZOoM3K8J+yebFMVwwhWQ@mail.gmail.com>
Date: Tue, 16 Dec 2014 00:09:54 +0000
Message-ID: <CADBe_Tu72XRS=EFEcdLK8wLLsLO60NSvSw18=Rb0aaSeg3WiSg@mail.gmail.com>
Subject: Re: Instalation issue on S960
From: Mark Clarkstone <hello@markclarkstone.co.uk>
To: Carlos Diogo <cdiogo@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I was recently trying to build drivers for another tuner on a Pi and
also came across a similar problem [unable to find symbols], it turns
out that the Raspberry Pi kernel doesn't have I2C_MUX enabled which is
needed by some modules.

You could try rebuilding the kernel with the above option enabled and
see if that helps.

Although I could be totally wrong and hopefully someone with more
knowledge will know (I'm still pretty much a Linux noob :p).

Hope this helps.

On 15 December 2014 at 23:13, Carlos Diogo <cdiogo@gmail.com> wrote:
> Dear support team ,
> i have spent 4 days trying to get my S960 setup in my raspberrry Pi
>
> I have tried multiple options and using the linuxtv.org drivers the
> power light switches on but then i get the below message
>
>
>
> [    8.561909] usb 1-1.5: dvb_usb_v2: found a 'DVBSky S960/S860' in warm state
> [    8.576865] usb 1-1.5: dvb_usb_v2: will pass the complete MPEG2
> transport stream to the software demuxer
> [    8.591803] DVB: registering new adapter (DVBSky S960/S860)
> [    8.603974] usb 1-1.5: dvb_usb_v2: MAC address: 00:18:42:54:96:0c
> [    8.650257] DVB: Unable to find symbol m88ds3103_attach()
> [    8.661452] usb 1-1.5: dvbsky_s960_attach fail.
> [    8.683560] usbcore: registered new interface driver dvb_usb_dvbsky
>
> I have tried googling it but i have found nothing about this
>
> i'm using raspbian , with kernel 3.12.34
>
> Any help here?
>
> Thanks in advance
> Carlos
>
>
> --
> Os meus cumprimentos / Best regards /  Mit freundlichen Grüße
> Carlos Diogo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
