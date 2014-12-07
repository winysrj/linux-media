Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40062 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752083AbaLGAH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Dec 2014 19:07:28 -0500
Date: Sun, 7 Dec 2014 02:07:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH for v3.19 0/4] v4l2-mediabus.h & documentation updates
Message-ID: <20141207000722.GE15559@valkosipuli.retiisi.org.uk>
References: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417789164-28468-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 05, 2014 at 03:19:20PM +0100, Hans Verkuil wrote:
> These patches change the type of the two new fields in struct v4l2_mbus_framefmt
> from __u32 to __u16, as per Sakari's suggestion. We don't need 4 bytes per field
> for this, and this way we save one __u32.
> 
> It also updates docbook with the new fields (I somehow missed that) and
> documents the new vivid controls in vivid.txt.

For the set:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
