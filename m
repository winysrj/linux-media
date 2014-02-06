Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40077 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751427AbaBFRfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Feb 2014 12:35:25 -0500
Date: Thu, 6 Feb 2014 19:34:52 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 26/47] v4l: Improve readability by not wrapping ioctl
 number #define's
Message-ID: <20140206173451.GK15635@valkosipuli.retiisi.org.uk>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1391618558-5580-27-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391618558-5580-27-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 05, 2014 at 05:42:17PM +0100, Laurent Pinchart wrote:
> Wrapping the #define's at a 80 columns boundary just obfuscates the
> code. Don't do that.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
