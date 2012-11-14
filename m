Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38156 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1423401Ab2KNVPG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 16:15:06 -0500
Date: Wed, 14 Nov 2012 23:15:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH 1/1] media: Entities with sink pads must have at least
 one enabled link
Message-ID: <20121114211502.GV25623@valkosipuli.retiisi.org.uk>
References: <1351280777-4936-1-git-send-email-sakari.ailus@iki.fi>
 <20121113142409.GR25623@valkosipuli.retiisi.org.uk>
 <50A36307.50502@samsung.com>
 <2181130.3OlxHxCofA@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2181130.3OlxHxCofA@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 11:58:42AM +0100, Laurent Pinchart wrote:
> I think my preference would go for a helper function that drivers can use, 
> possibly first waiting until a second driver requires this kind of checks 
> before implementing it.

I'd like to see a driver that doesn't. Quite likelye either it has no
configurable links or it's broken. :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
