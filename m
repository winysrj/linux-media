Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55513 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756416Ab3AYMjE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 07:39:04 -0500
Date: Fri, 25 Jan 2013 14:38:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-media@vger.kernel.org, jtp.park@samsung.com,
	arun.kk@samsung.com, s.nawrocki@samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	m.szyprowski@samsung.com, pawel@osciak.com
Subject: Re: [PATCH 0/2 v3] Add proper timestamp types handling in videobuf2
Message-ID: <20130125123858.GF18639@valkosipuli.retiisi.org.uk>
References: <1359109797-12698-1-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359109797-12698-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 25, 2013 at 11:29:55AM +0100, Kamil Debski wrote:
> Hi,
> 
> This is the third version of the patch posted earlier this month.
> After the discussion a WARN_ON was added to inform if the driver is not setting
> timestamp type when initialising the videobuf2 queue. Small correction to the
> documentation was also made and two patche were squashed to avoid problems
> with bisect.
> 
> Also the davinci/vpbe_display.c driver was modified to correctly report the use
> of MONOTONIC timestamp type.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
