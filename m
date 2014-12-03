Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38603 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752319AbaLCMc3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Dec 2014 07:32:29 -0500
Date: Wed, 3 Dec 2014 14:31:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] Media cleanups
Message-ID: <20141203123157.GH14746@valkosipuli.retiisi.org.uk>
References: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417439445-34862-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 01, 2014 at 02:10:41PM +0100, Hans Verkuil wrote:
> This patch series:
> 
> - Removes all the emacs editor variables in sources.
> - Stops drivers from using the debug field in struct video_device.
>   This field is internal to the v4l2 core and drivers shouldn't
>   set it.
> - Improve debug flag handling.
> - Document the debug attribute.

Nice set!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
