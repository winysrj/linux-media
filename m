Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33381 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757513Ab3GaVJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 17:09:14 -0400
Date: Thu, 1 Aug 2013 00:08:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Katsuya MATSUBARA <matsu@igel.co.jp>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v4 7/7] vsp1: Use the maximum number of entities defined
 in platform data
Message-ID: <20130731210840.GS12281@valkosipuli.retiisi.org.uk>
References: <1375285954-32153-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1375285954-32153-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375285954-32153-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 31, 2013 at 05:52:34PM +0200, Laurent Pinchart wrote:
> From: Katsuya Matsubara <matsu@igel.co.jp>
> 
> The VSP1 driver allows to define the maximum number of each module
> such as RPF, WPF, and UDS in a platform data definition.
> This suppresses operations for nonexistent or unused modules.
> 
> Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
