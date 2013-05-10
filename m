Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54804 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753487Ab3EJPZF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 11:25:05 -0400
Date: Fri, 10 May 2013 18:25:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl
Subject: Re: [PATCH v2 1/1] v4l: Document timestamp behaviour to correspond
 to reality
Message-ID: <20130510152500.GH1075@valkosipuli.retiisi.org.uk>
References: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364076274-726-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 24, 2013 at 12:04:34AM +0200, Sakari Ailus wrote:
> Document that monotonic timestamps are taken after the corresponding frame
> has been received, not when the reception has begun. This corresponds to the
> reality of current drivers: the timestamp is naturally taken when the
> hardware triggers an interrupt to tell the driver to handle the received
> frame.
> 
> Remove the note on timestamp accurary as it is fairly subjective what is
> actually an unstable timestamp.
> 
> Also remove explanation that output buffer timestamps can be used to delay
> outputting a frame.
> 
> Remove the footnote saying we always use realtime clock.

Ping.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
