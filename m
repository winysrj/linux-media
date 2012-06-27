Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:19612 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab2F0LUi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 07:20:38 -0400
Message-ID: <4FEAEC71.5000000@iki.fi>
Date: Wed, 27 Jun 2012 14:20:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Jean-Philippe Francois <jp.francois@cynove.com>,
	Abhishek Reddy Kondaveeti <areddykondaveeti@aptina.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Subject: Re: [PATCH 5/6] omap3isp: ccdc: Remove ispccdc_syncif structure
References: <1340718339-29915-1-git-send-email-laurent.pinchart@ideasonboard.com> <1340718339-29915-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340718339-29915-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> The structure is only used to store configuration data and pass it to
> CCDC configuration functions. Access the data directly from the
> locations that need it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>


-- 
Sakari Ailus
sakari.ailus@iki.fi


