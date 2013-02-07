Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39425 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758200Ab3BGM13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:27:29 -0500
Date: Thu, 7 Feb 2013 14:27:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [GIT PULL FOR v3.9] Move cx2341x from media/i2c to media/common
Message-ID: <20130207122724.GB22278@valkosipuli.retiisi.org.uk>
References: <201301290956.20849.hverkuil@xs4all.nl>
 <201302060846.35774.hverkuil@xs4all.nl>
 <20130206071604.768c77b5@redhat.com>
 <2512397.bTxYQxHEiJ@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2512397.bTxYQxHEiJ@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Feb 06, 2013 at 10:41:16AM +0100, Laurent Pinchart wrote:
> On Wednesday 06 February 2013 07:16:04 Mauro Carvalho Chehab wrote:
> > Em Wed, 6 Feb 2013 08:46:35 +0100 Hans Verkuil escreveu:
> > > At least aptina-pll.c, smiapp-pll.c and tveeprom.c all have some
> > > relationship with i2c.
> > 
> > True, but none of the three are actually i2c drivers; they're just shared
> > functions used by drivers helper code.
> > 
> > Hmm...
> > 
> > $ git grep aptina-pll.h drivers/media/
> > drivers/media/i2c/aptina-pll.c:#include "aptina-pll.h"
> > drivers/media/i2c/mt9m032.c:#include "aptina-pll.h"
> > drivers/media/i2c/mt9p031.c:#include "aptina-pll.h"
> > 
> > $ git grep smiapp-pll.h drivers/media/
> > drivers/media/i2c/smiapp-pll.c:#include "smiapp-pll.h"
> > drivers/media/i2c/smiapp-pll.h: * drivers/media/i2c/smiapp-pll.h
> > drivers/media/i2c/smiapp/smiapp.h:#include "smiapp-pll.h"
> > 
> > $ git grep smiapp.h drivers/media/
> > drivers/media/i2c/smiapp/smiapp-core.c:#include "smiapp.h"
> > drivers/media/i2c/smiapp/smiapp-limits.c:#include "smiapp.h"
> > drivers/media/i2c/smiapp/smiapp-quirk.c:#include "smiapp.h"
> > drivers/media/i2c/smiapp/smiapp-regs.c:#include "smiapp.h"
> > drivers/media/i2c/smiapp/smiapp.h: * drivers/media/i2c/smiapp/smiapp.h
> > drivers/media/i2c/smiapp/smiapp.h:#include <media/smiapp.h>
> > 
> > It could make sense to keep those two on I2c,
> 
> I'd like that :-) Those helper functions will likely never be used by non-I2C 
> drivers. If they are we can reconsider moving them to common/, but for now it 
> makes sense to keep them in i2c/ in my opinion.

Ack to that. I2c is the bus for the time being but the CSI-3 is
bi-directional:

<URL:http://www.design-reuse.com/sip/30046/mipi-csi-3-camera-serial-interface-receiver/>

The sensors using that bus may well have entirely different PLLs though.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
