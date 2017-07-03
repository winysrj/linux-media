Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54046 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751713AbdGCM2K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 08:28:10 -0400
Date: Mon, 3 Jul 2017 15:28:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] media: Make parameter of
 media_entity_remote_pad() const
Message-ID: <20170703122805.lhbtbtivowgjzjhv@valkosipuli.retiisi.org.uk>
References: <1499083691-30112-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499083691-30112-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 03, 2017 at 03:08:11PM +0300, Todor Tomov wrote:
> The local pad parameter in media_entity_remote_pad() is not modified.
> Make that explicit by adding a const modifier.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
