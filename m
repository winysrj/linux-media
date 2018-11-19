Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:57659 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbeKTJp7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 04:45:59 -0500
Received: from roadrunner.suse (p5B318D4A.dip0.t-ipconnect.de [91.49.141.74])
        by mail.eclipso.de with ESMTPS id 7A118436
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2018 00:19:56 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Tue, 20 Nov 2018 00:19:54 +0100
Message-ID: <1837109.xExTbI5ikD@roadrunner.suse>
In-Reply-To: <20181119210845.38072faf@coco.lan>
References: <s5hbm6l5cdi.wl-tiwai@suse.de> <2988162.jBOhpiBzca@roadrunner.suse> <20181119210845.38072faf@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data martedì 20 novembre 2018 00:08:45 CET, Mauro Carvalho Chehab ha 
scritto:
>  uname -a
> 
> > Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon Nov 19
> > 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux

 uname -a         
> Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon Nov 19 
> 18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux

from https://download.opensuse.org/repositories/home:/tiwai:/bsc1116374/
standard/x86_64/

So I booted this one, should be the right one. 
sudo dmesg | grep -i b2c2   should give these additional messages? 

If Takashi is still around, he could confirm. 



_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postfächer sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
