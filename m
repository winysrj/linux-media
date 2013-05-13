Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55266 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751547Ab3EMPzY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 11:55:24 -0400
Date: Mon, 13 May 2013 18:55:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] [media] omap3isp: Remove redundant platform_set_drvdata()
Message-ID: <20130513155519.GA22507@valkosipuli.retiisi.org.uk>
References: <1368436674-11876-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368436674-11876-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On Mon, May 13, 2013 at 02:47:54PM +0530, Sachin Kamat wrote:
> Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
> driver is bound) removes the need to set driver data field to
> NULL.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
