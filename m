Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36211 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab2GFLFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 07:05:11 -0400
Received: by wibhm11 with SMTP id hm11so720618wib.1
        for <linux-media@vger.kernel.org>; Fri, 06 Jul 2012 04:05:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKLOr0J1JjpCMRf4toJ5uBMDAFZT8VGdFuX6MpUpxpNaAO_SA@mail.gmail.com>
References: <1338543105-20322-1-git-send-email-javier.martin@vista-silicon.com>
	<CACKLOr0J1JjpCMRf4toJ5uBMDAFZT8VGdFuX6MpUpxpNaAO_SA@mail.gmail.com>
Date: Fri, 6 Jul 2012 13:05:10 +0200
Message-ID: <CACKLOr1ZJ4F7+-U94EQ5AD=1z3-HVU1=uK9yjAv+JgfqjTKo0g@mail.gmail.com>
Subject: Re: [PATCH v3][for_v3.5] media: mx2_camera: Fix mbus format handling
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, fabio.estevam@freescale.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 July 2012 13:00, javier Martin <javier.martin@vista-silicon.com> wrote:
> Hi,
> can this patch be applied please?
>
> It solves a BUG for 3.5. Guennadi, Fabio, could you give me an ack for this?
>
> Regards.

But it should be applied after this one to preserve bisectability:

http://patchwork.linuxtv.org/patch/10483/

So I'd better send a new series to clarify the order.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
