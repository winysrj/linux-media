Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47083 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HTGX5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 02:23:57 -0400
Received: by wibhr14 with SMTP id hr14so3399758wib.1
        for <linux-media@vger.kernel.org>; Sun, 19 Aug 2012 23:23:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120820030339.GB4011@b20223-02.ap.freescale.net>
References: <1343043061-24327-1-git-send-email-javier.martin@vista-silicon.com>
	<20120803082442.GE29944@b20223-02.ap.freescale.net>
	<201208031047.01174.hverkuil@xs4all.nl>
	<20120803090329.GA15809@b20223-02.ap.freescale.net>
	<CACKLOr2XRz5edR0ZEE3UFD5enbUEMi+OkfRsn1JvOmh=NBqt8A@mail.gmail.com>
	<20120820030339.GB4011@b20223-02.ap.freescale.net>
Date: Mon, 20 Aug 2012 08:23:55 +0200
Message-ID: <CACKLOr1h2Mb9tGPGUOPG6z1hfNHWMHUNL2+6QbrzRFbo8C3ATw@mail.gmail.com>
Subject: Re: [v7] media: coda: Add driver for Coda video codec.
From: javier Martin <javier.martin@vista-silicon.com>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com,
	mchehab@infradead.org, s.hauer@pengutronix.de,
	p.zabel@pengutronix.de, linuxzsc@gmail.com, shawn.guo@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20 August 2012 05:03, Richard Zhao <richard.zhao@freescale.com> wrote:
> Hi Javier,
>
> Did the patch get picked? I didn't see it on
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git

It got merged 6 days ago in 'for_v3.7' branch of the linux-media tree:

http://git.linuxtv.org/media_tree.git/commitdiff/186b250a07253770717f41eee911b8c5467be04e?hp=6d8c4529f8058b4e8c902fe689786877f2224060


>
> Still, how did you test this v4l2 device?

Using V4L2 API in a mem2mem basis, i.e. the driver has one output and
one capture interface that must be configured independently.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
