Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:63487 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2AWIBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 03:01:18 -0500
Received: by wics10 with SMTP id s10so1876307wic.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2012 00:01:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201221939340.1075@axis700.grange>
References: <1326297664-19089-1-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201211827381.16722@axis700.grange>
	<Pine.LNX.4.64.1201221939340.1075@axis700.grange>
Date: Mon, 23 Jan 2012 09:01:16 +0100
Message-ID: <CACKLOr1nemP0Wr5zEhGed7s+kGvTFq0t0NAfipRBwHPvVLB78g@mail.gmail.com>
Subject: Re: [PATCH v2] media i.MX27 camera: properly detect frame loss.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
thank you for your attention.

I've recently sent a new patch series on top of this patch:
[PATCH 0/4] media i.MX27 camera: fix buffer handling and videobuf2
support. (http://www.mail-archive.com/linux-media@vger.kernel.org/msg42255.html)

Among other things, it adds videobuf2 support and adds "stream_stop"
and "stream_start" callbacks which allow to enable/disable capturing
of buffers at the right moment.
This also makes the sequence number trick disappear and a much cleaner
approach is used instead.

I suggest you hold on this patch until the new series is accepted and
then merge both at the same time.

What do you think?



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
