Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58764 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751144AbdHEIBc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 Aug 2017 04:01:32 -0400
Subject: Re: [PATCH] media: i2c: adv748x: Store the pixel rate ctrl on CSI
 objects
To: Kieran Bingham <kbingham@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, niklas.soderlund@ragnatech.se
Cc: kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <1501768223-23654-1-git-send-email-kbingham@kernel.org>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <f9219815-55c3-c7d7-0812-3b97144d9cfe@iki.fi>
Date: Fri, 4 Aug 2017 20:09:34 +0300
MIME-Version: 1.0
In-Reply-To: <1501768223-23654-1-git-send-email-kbingham@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> The current implementation has to search the list of controls for the
> pixel rate control, each time it is set.  This can be optimised easily
> by storing the ctrl pointer in the CSI/TX object, and referencing that
> directly.
> 
> While at it, fix up a missing blank line also highlighted in review
> comments.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@iki.fi
