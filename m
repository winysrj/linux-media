Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604Ab1LGTtK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 14:49:10 -0500
Message-ID: <4EDFC333.2040201@redhat.com>
Date: Wed, 07 Dec 2011 17:49:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: gennarone@gmail.com, linux-media list <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/1] xc3028: force reload of DTV7 firmware in VHF band
 with Zarlink demodulator
References: <4EDE27A0.8060406@gmail.com> <4EDF6640.801@redhat.com> <4EDF6E7E.30200@gmail.com> <4EDF762A.9030604@redhat.com> <4EDF7DF3.1080007@gmail.com> <4EDF80AF.5060709@redhat.com> <4EDF8A22.6020201@gmail.com> <4EDF8B68.1040009@gmail.com> <4EDF9291.2030703@redhat.com> <4EDFA19E.7090608@gmail.com> <4EDFB746.8010309@redhat.com> <4EDFBF17.5040407@gmail.com>
In-Reply-To: <4EDFBF17.5040407@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07-12-2011 17:31, Gianluca Gennari wrote:

> thanks a lot for the detailed explanation, but it is not needed anymore.
> I think I got it: reading the comments in the code and in particular a
> couple of weird "hacks", I think I figured out what is going on.
>
> I have prepared a patch that fixes center frequency adjustment:
> basically, this let us get rid of this weird code:
>
>
> 		if ((priv->cur_fw.type&  DTV78)&&  freq<  470000000)
> 			offset -= 500000;
>
> which assumes all channels below 470000000 have 7MHz bw.
>
> Also we can get rid of this adjustment that seems to come out of nowhere:
>
> 		if (priv->cur_fw.type&  DTV7)
> 			offset += 500000;
>
> Maybe those hacks where necessary for old firmwares, but the updated
> ones (a comment mentions updates SCODE tables, whatever this means)
> seems to use the same center frequency value for all bandwidths and all
> firmwares (well, at least DTV7, DTV8 and DTV78; we will never know about
> DTV6).

Old firmwares behave like newer ones, AFAIK. DTV78 is there since at least
firmware v2.2.

>
> I tested this patch with all firmwares:
> DTV7 ->  OK in VHF band
> DTV8 ->  OK in UHF band
> DTV78 ->  OK in both VHF and UHF
>
> Please note also that the patch is not changing anything for DTV7 and
> DTV8 firmwares. The only thing really affected is the center frequency
> calculation for DTV78 firmware in VHF band.
>
> What do you think about it?

It makes sense. The offset adjustment should be done based on the bandwidth
and if the firmware is either DTV78 or DTV7/DTV8, and not based on the frequency.

> By the way, DVB-T tables from dvb-apps are really outdated, and anyway
> they are completely useless in Italy. Here we have a jungle of
> frequencies (about 50 in my area), which are
> appearing/disappearing/changing some modulation parameter almost every
> day, and also if you move a few km away you will probably get some
> different ones.
> So no table will be ever up-to-date, and even if it is, it will be only
> useful to the person who created it. Maybe in a year or two the
> situation will stabilize (after the switch-off is completed everywhere),
> but until then it's a mess.

It would be nice to at least fix the auto-italy table, in order for it to match
whatever Italy channel frequencies are in use, currently.

>
> Best regards,
> Gianluca

Regards,
Mauro
