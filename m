Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:58100 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935524Ab1JEXUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Oct 2011 19:20:17 -0400
Date: Thu, 6 Oct 2011 02:20:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller
 framework and add video format detection
Message-ID: <20111005232013.GD8614@valkosipuli.localdomain>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <CAAwP0s0bTcUPvkVT-aB2EKskS_60CdW4P3orQLvSJMMkEWBpqw@mail.gmail.com>
 <4E8A07A6.3030600@infradead.org>
 <201110032339.31549.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110032339.31549.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 03, 2011 at 11:39:31PM +0200, Laurent Pinchart wrote:
> Sorry ? We already have format setting at the pad level, and that's used by 
> drivers and applications. It's one key feature of the V4L2/MC API.

A tiny additional note: this feature is actuall necessary since e.g. OMAP 3
ISP CCDC provides images of different size at different outputs; one to
memory and one to another ISP block.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
