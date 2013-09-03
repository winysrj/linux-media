Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55877 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761461Ab3ICX5W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Sep 2013 19:57:22 -0400
Date: Wed, 4 Sep 2013 02:56:47 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v1.1 3/5] media: Pads that are not connected by even a
 disabled link are fine
Message-ID: <20130903235647.GD4493@valkosipuli.retiisi.org.uk>
References: <1611138.kmhZXgyzhc@avalon>
 <1377966487-22565-1-git-send-email-sakari.ailus@iki.fi>
 <1806796.1hWpdenVOE@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1806796.1hWpdenVOE@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the comments!!

On Tue, Sep 03, 2013 at 08:07:43PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 31 August 2013 19:28:06 Sakari Ailus wrote:
> > Do not require a connected link to a pad if a pad has no links connected to
> > it.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> > Hi Laurent,
> > 
> > This goes on top of patch 2/4. I can combine the two in the end but I think
> > this is cleaner as a separate change.
> 
> Merging the patches separately could result in a bisection breakage, so I'd 
> rather combine the patches if that's OK. What about the following commit 
> message ?

I'm certainly fine with that. Let me resend the patch.

> "media: Check for active links on pads with MEDIA_PAD_FL_MUST_CONNECT flag
> 
> Do not allow streaming if a pad with MEDIA_PAD_FL_MUST_CONNECT flag is 
> connected by links that are all inactive.
> 
> This patch makes it possible to avoid drivers having to check for the most
> common case of link state validation: a sink pad that must be connected."

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
