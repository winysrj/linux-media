Return-path: <linux-media-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:56560 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbCSICA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 04:02:00 -0400
Message-ID: <550A74E3.3070702@compulab.co.il>
Date: Thu, 19 Mar 2015 09:04:03 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
CC: linux-omap@vger.kernel.org, tony@atomide.com, sre@kernel.org,
	pali.rohar@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 06/15] omap3isp: Refactor device configuration structs
 for Device Tree
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi> <1426465570-30295-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1426465570-30295-7-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/15 02:26, Sakari Ailus wrote:
> Make omap3isp configuration data structures more suitable for consumption by
> the DT by separating the I2C bus information of all the sub-devices in a
> group and the ISP bus information from each other. The ISP bus information
> is made a pointer instead of being directly embedded in the struct.
> 
> In the case of the DT only the sensor specific information on the ISP bus
> configuration is retained. The structs are renamed to reflect that.
> 
> After this change the structs needed to describe device configuration can be
> allocated and accessed separately without those needed only in the case of
> platform data. The platform data related structs can be later removed once
> the support for platform data can be removed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Igor Grinberg <grinberg@compulab.co.il>

For cm-t35 stuff:

Acked-by: Igor Grinberg <grinberg@compulab.co.il>

-- 
Regards,
Igor.
