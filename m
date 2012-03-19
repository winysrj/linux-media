Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48097 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab2CSWhf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 18:37:35 -0400
Date: Mon, 19 Mar 2012 23:37:29 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alex Gershgorin <alexg@meprolight.com>,
	linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
	fabio.estevam@freescale.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] i.MX35-PDK: Add Camera support
Message-ID: <20120319223729.GC3852@pengutronix.de>
References: <1331651129-30540-1-git-send-email-alexg@meprolight.com>
 <4F67AD31.8030500@redhat.com>
 <4F67B077.5050300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F67B077.5050300@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 19, 2012 at 07:17:27PM -0300, Mauro Carvalho Chehab wrote:
> Em 19-03-2012 19:03, Mauro Carvalho Chehab escreveu:
> > Em 13-03-2012 12:05, Alex Gershgorin escreveu:
> >> In i.MX35-PDK, OV2640  camera is populated on the
> >> personality board. This camera is registered as a subdevice via soc-camera interface.
> >>
> >> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> > 
> > Patch doesn't apply over v3.3:
> 
> Sorry, the previous version of this patch didn't apply. This compiles OK.
> 
> Sorry for the mess.
> 
> Anyway, it should be applied via arm subtree.

It's scheduled there. I should have responded with an applied message.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
