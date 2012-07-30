Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2G3PdQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 11:33:16 -0400
Date: Mon, 30 Jul 2012 17:33:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-arm-kernel@lists.infradead.org, mchehab@redhat.com,
	linux@arm.linux.org.uk, kernel@pengutronix.de,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] media: mx2_camera: Remove MX2_CAMERA_SWAP16 and
 MX2_CAMERA_PACK_DIR_MSB flags.
In-Reply-To: <CACKLOr2sKVWCk3we_cP5MvnR6-WsaFwA9AC=fgp3iLm8B6mfEA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1207301718510.28003@axis700.grange>
References: <1342083809-19921-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1207201330240.27906@axis700.grange>
 <CACKLOr2sKVWCk3we_cP5MvnR6-WsaFwA9AC=fgp3iLm8B6mfEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Mon, 30 Jul 2012, javier Martin wrote:

> Hi,
> thank you for yor ACKs.
> 
> On 20 July 2012 13:31, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > On Thu, 12 Jul 2012, Javier Martin wrote:
> >
> >> These flags are not used any longer and can be safely removed
> >> since the following patch:
> >> http://www.spinics.net/lists/linux-media/msg50165.html
> >>
> >> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> >
> > For the ARM tree:
> >
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> forgive my ignorance on the matter. Could you please point me to the
> git repository this patch should be merged?

Sorry, my "for the ARM tree" comment was probably not clear enough. This 
patch should certainly go via the ARM (SoC) tree, since it only touches 
arch/arm. So, the maintainer (Sascha - added to CC), that will be 
forwarding this patch to Linus can thereby add my "acked-by" to this 
patch, if he feels like it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
