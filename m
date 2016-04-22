Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:33590 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbcDVIzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 04:55:03 -0400
Message-ID: <1461315288.4047.19.camel@pengutronix.de>
Subject: Re: [PATCHv3 01/12] vb2: add a dev field to use for the default
 allocation context
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Florian Echtler <floe@butterbrot.org>,
	Federico Vaga <federico.vaga@gmail.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Benoit Parrot <bparrot@ti.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Ludovic Desroches <ludovic.desroches@atmel.com>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Date: Fri, 22 Apr 2016 10:54:48 +0200
In-Reply-To: <1461314299-36126-2-git-send-email-hverkuil@xs4all.nl>
References: <1461314299-36126-1-git-send-email-hverkuil@xs4all.nl>
	 <1461314299-36126-2-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 22.04.2016, 10:38 +0200 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The allocation context is nothing more than a per-plane device pointer
> to use when allocating buffers. So just provide a dev pointer in vb2_queue
> for that purpose and drivers can skip allocating/releasing/filling in
> the allocation context unless they require different per-plane device
> pointers as used by some Samsung SoCs.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Florian Echtler <floe@butterbrot.org>
> Cc: Federico Vaga <federico.vaga@gmail.com>
> Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> Cc: Scott Jiang <scott.jiang.linux@gmail.com>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Cc: Fabien Dessenne <fabien.dessenne@st.com>
> Cc: Benoit Parrot <bparrot@ti.com>
> Cc: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

