Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:34546 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440431AbeKXCkZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 21:40:25 -0500
Received: from roadrunner.suse (p5B318167.dip0.t-ipconnect.de [91.49.129.103])
        by mail.eclipso.de with ESMTPS id 077207E5
        for <linux-media@vger.kernel.org>; Fri, 23 Nov 2018 16:55:37 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Fri, 23 Nov 2018 16:55:35 +0100
Message-ID: <4969775.51lmc1uXLO@roadrunner.suse>
In-Reply-To: <20181122183549.331ecbc4@coco.lan>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de> <12757009.r0OKxgvFl0@roadrunner.suse> <20181122183549.331ecbc4@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data giovedì 22 novembre 2018 21:35:49 CET, Mauro Carvalho Chehab ha 
scritto:
> Em Thu, 22 Nov 2018 21:19:49 +0100
> 
> stakanov <stakanov@eclipso.eu> escreveu:
> > Hello Mauro.
> > 
> > Thank you so much, for this fast reply and especially for the detailed
> > indications. I expected to have a lack of knowledge.
> > 
> > Well,  I am replying to the question as of below: (for convenience I did
> > cut the before text, if you deem it useful for the list I can then
> > correct that in the next posts).
> > 
> > In data giovedì 22 novembre 2018 21:06:11 CET, Mauro Carvalho Chehab ha
> > 
> > scritto:
> > > Are you sure that the difference is just the Kernel version? Perhaps you
> > > also updated some other package.
> > 
> > To be clear: I had the same system(!) with all three kernel 4.18.15-1,
> > 4.19.1 (when the problem did arise) and 4.20.2 rc3 from Takashi's repo)
> > installed.
> Ok, so rebooting to 4.18.15-1 solves the issue?
> 
> Also, what GPU driver are you using?
> 
> In any case, by using the old "Universal" LNBf, you're likely missing some
> transponders, and missing several channels.
> 
> > In this very configuration: if one booted in 4.18 (that is in perfect
> > parity with all other packages) the card worked. 4.19.1 no. And the last
> > kernel the same. So whatever might be different, forcefully it has to be
> > in the kernel. (Which is not really a problem if I manage to make it
> > work, so settings will be known to others or, if not, we will find out
> > what is different, and all will be happy. As you see I am still
> > optimist).
> 
> Well, we don't want regressions in Kernel. If there's an issue there,
> it should be fixed. However, I can't think on any other changes since
> 4.18 that would be causing troubles for b2c2 driver.
> 
> See, the only change at the driver itself is just a simple API
> replacement that wouldn't cause this kind of problems:
> 
> 	$ git log --oneline v4.18.. drivers/media/common/b2c2/
> 	c0decac19da3 media: use strscpy() instead of strlcpy()
> 
> There were a few changes at the DVB core:
> 
> 	$ git log --no-merges --oneline v4.18.. drivers/media/dvb-core/
> 	f3efe15a2f05 media: dvb: use signal types to discover pads
> 	b5d3206112dd media: dvb: dmxdev: move compat_ioctl handling to dmxdev.c
> 	cc1e6315e83d media: replace strcpy() by strscpy()
> 	c0decac19da3 media: use strscpy() instead of strlcpy()
> 	fd89e0bb6ebf media: videobuf2-core: integrate with media requests
> 	db6e8d57e2cd media: vb2: store userspace data in vb2_v4l2_buffer
> 	6a2a1ca34ca6 media: dvb_frontend: ensure that the step is ok for both FE
> and tuner f1b1eabff0eb media: dvb: represent min/max/step/tolerance freqs
> in Hz a3f90c75b833 media: dvb: convert tuner_info frequencies to Hz
> 	6706fe55af6f media: dvb_ca_en50221: off by one in
> dvb_ca_en50221_io_do_ioctl() 4d1e4545a659 media: mark entity-intf links as
> IMMUTABLE
> 
> But, on a first glance, the only ones that has potential to cause issues
> were the ones addressed that the patch I wrote (merged by Takashi).
> 
> If you're really receiving data from EPG (you may just have it
> cached), it means that the DVB driver is doing the right thing.
> 
> Btw, to be sure that you're not just seeing the old EPG data, you
> should move or remove this file:
> 
> 	~/.local/share/kaffeine/epgdata.dvb
> 
> Kaffeine will generate a new one again once it tunes into a TV channel.
> 
> > I will proceed as indicated and report back here tomorrow.
> 
> Ok.
> 
> Thanks,
> Mauro
So, I confirm that:
a) 4.18.15-1 this card worked flawlessly.
b) above that, included the kernel with correction, it does not work any more.
c) downloading and copying the respective firmware from openelec does not 
change, the card stays dead. 
d) astra: no search of channels, search interrupted after seconds.
e) hotbird: search without finding any channel - only noise
f) lnbf setting was to "Astra E" as indicated. 
g) after erasing the file in local/share it is clear that EPG data does NOT 
work either.
When using the channels as they were recorded before, the signal strength is 0 
but the fictional led is green (as if it would receive). 



No picture, no tone, no channel sync, no EPG. A brick. 
So, with 4.18 that worked, only that now (due to an error I lost access to the 
4.18.15-1 driver of TW, so if Takashi has a link, I can reinstall it and we 
can check if, parity all packages this is still the case. I assure you that it 
was, but that would be a perfect proof. 
Firmware downloaded and installed in /lib/firmware was:
https://www.linuxtv.org/wiki/index.php/TechniSat_SkyStar_S2 following the link 
to open Elec:

https://github.com/OpenELEC/dvb-firmware/blob/master/firmware/dvb-fe-cx24120-1.20.58.2.fw





_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postfächer sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
