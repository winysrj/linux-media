Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55848 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752340Ab3FHLsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jun 2013 07:48:15 -0400
Date: Sat, 8 Jun 2013 14:47:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] omap3isp: ccp2: Don't ignore the regulator_enable()
 return value
Message-ID: <20130608114740.GH3103@valkosipuli.retiisi.org.uk>
References: <1370675502-3136-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370675502-3136-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sat, Jun 08, 2013 at 09:11:42AM +0200, Laurent Pinchart wrote:
> Check the return value and catch errors correctly.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
