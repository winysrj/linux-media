Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41702 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751769AbaD3IjK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 04:39:10 -0400
Date: Wed, 30 Apr 2014 11:38:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] omap3isp: Make isp_register_entities() fail when sensor
 registration fails
Message-ID: <20140430083830.GR8753@valkosipuli.retiisi.org.uk>
References: <1398845671-12989-1-git-send-email-pmeerw@pmeerw.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398845671-12989-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Peter,

On Wed, Apr 30, 2014 at 10:14:31AM +0200, Peter Meerwald wrote:
> isp_register_entities() ignores registration failure of the sensor,
> /dev/video* devices are created nevertheless
> 
> if the sensor fails, all entities should not be created

Why? In some cases it'd be nice to be able to use the devices that actually
are available. This certainly isn't something that should cause probe to
fail IMHO.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
