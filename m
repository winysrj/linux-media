Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40432 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLmw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:42:52 -0400
Received: by mail-wg0-f41.google.com with SMTP id ds1so1954420wgb.0
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 04:42:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1303111208170.21241@axis700.grange>
References: <CACKLOr22R45bCbfntvhLVh=kf2fGq6umXZtDsKjsNVbNHAK6Rw@mail.gmail.com>
	<962516300.332041.1362658383433.JavaMail.root@advansee.com>
	<CACKLOr2VOb3GMiX6GVmSchhGs8XeBJ0c7qRSHZwU8e8C+qeWPg@mail.gmail.com>
	<1201392585.355417.1362743602969.JavaMail.root@advansee.com>
	<CACKLOr0FEO3wvpZpn=Fg9ZSBYLDnY-hY=KysD72JVbrcVChArg@mail.gmail.com>
	<1700189562.356790.1362748660082.JavaMail.root@advansee.com>
	<Pine.LNX.4.64.1303081903250.24912@axis700.grange>
	<Pine.LNX.4.64.1303111208170.21241@axis700.grange>
Date: Mon, 11 Mar 2013 12:42:36 +0100
Message-ID: <CACKLOr2LPL_jG5SAbmsU=Vh_ZhfXQ6ZDoP_+WOUARKm3Mz7QBw@mail.gmail.com>
Subject: Re: mt9m111/mt9m131: kernel 3.8 issues.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: =?ISO-8859-1?Q?Beno=EEt_Th=E9baudeau?=
	<benoit.thebaudeau@advansee.com>, linux-media@vger.kernel.org,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>> I just tested my mt9m131 camera on a i.MX31 board, if not this your email
>> I don't think I'd be alarmed by the image quality it's producing, maybe
>> I'm just less picky:-) And yes, in general I agree, I think, this level of
>> image quality tuning is difficult to achieve on modern cameras with 100s
>> of fine-tuning knobs. I'll try to re-test this camera in day light
>> conditions and post my best shot :)
>
> http://download.open-technology.de/mt9m131/
>
> .ppm is taken with mt9m131. Note, that I shot 10 frames and took the 3rd
> one - the first two are much darker, #3 is where autoexposure has kicked
> in, I suppose. Also note, that the comparison shot has been fired from a
> much smaller distance to cover a similar area due to obviously different
> lenses. I'll leave any colour-quality judgement to the reader(s) :-)

Thank you for your feedback. It seems that we all have a similar colour quality.
If Aptina comes up with better settings or I find them I'll post a
patch for you to test.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
