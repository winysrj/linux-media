Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46383 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750754AbaBWKjf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 05:39:35 -0500
Date: Sun, 23 Feb 2014 12:39:02 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	k.debski@samsung.com
Subject: Re: [PATCH v5.1 7/7] v4l: Document timestamp buffer flag behaviour
Message-ID: <20140223103902.GD15635@valkosipuli.retiisi.org.uk>
References: <20140217233305.GY15635@valkosipuli.retiisi.org.uk>
 <1392925376-20562-1-git-send-email-sakari.ailus@iki.fi>
 <530664CB.6000408@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530664CB.6000408@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 20, 2014 at 09:25:47PM +0100, Hans Verkuil wrote:
> On 02/20/2014 08:42 PM, Sakari Ailus wrote:
> > Timestamp buffer flags are constant at the moment. Document them so that 1)
> > they're always valid and 2) not changed by the drivers. This leaves room to
> > extend the functionality later on if needed.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks! :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
