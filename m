Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:56812 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392972AbeKWHAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 02:00:51 -0500
Received: from roadrunner.suse (p5B318127.dip0.t-ipconnect.de [91.49.129.39])
        by mail.eclipso.de with ESMTPS id 02899C28
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 21:19:52 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Thu, 22 Nov 2018 21:19:49 +0100
Message-ID: <12757009.r0OKxgvFl0@roadrunner.suse>
In-Reply-To: <20181122180611.2e7f1123@coco.lan>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de> <2836654.gWKGMNFOG2@roadrunner.suse> <20181122180611.2e7f1123@coco.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro. 

Thank you so much, for this fast reply and especially for the detailed 
indications. I expected to have a lack of knowledge. 

Well,  I am replying to the question as of below: (for convenience I did cut 
the before text, if you deem it useful for the list I can then correct that in 
the next posts).

In data giovedì 22 novembre 2018 21:06:11 CET, Mauro Carvalho Chehab ha 
scritto:
> Are you sure that the difference is just the Kernel version? Perhaps you
> also updated some other package.

To be clear: I had the same system(!) with all three kernel 4.18.15-1, 4.19.1  
(when the problem did arise) and 4.20.2 rc3 from Takashi's repo) installed. 

In this very configuration: if one booted in 4.18 (that is in perfect parity 
with all other packages) the card worked. 4.19.1 no. And the last kernel the 
same. So whatever might be different, forcefully it has to be in the kernel. 
(Which is not really a problem if I manage to make it work, so settings will 
be known to others or, if not, we will find out what is different, and all 
will be happy. As you see I am still optimist).  
I will proceed as indicated and report back here tomorrow. 

Regards. 




_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postfächer sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
