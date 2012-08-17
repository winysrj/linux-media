Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60798 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755420Ab2HQNos (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 09:44:48 -0400
Date: Fri, 17 Aug 2012 16:44:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Subject: Re: [PATCH v2] smiapp: Use devm_* functions in smiapp-core.c file
Message-ID: <20120817134443.GB32720@valkosipuli.retiisi.org.uk>
References: <1345178942-6771-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345178942-6771-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On Fri, Aug 17, 2012 at 10:19:02AM +0530, Sachin Kamat wrote:
> devm_* functions are device managed functions and make code a bit
> smaller and cleaner.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
> Changes since v1:
> Used devm_kzalloc for sensor->nvm.
> Used devm_clk_get and devm_regulator_get functions.
> 
> This patch is based on Mauro's re-organized tree
> (media_tree staging/for_v3.7) and is compile tested.

Thanks for the updated patch!

I've applied this and the other patch you sent ("[media] smiapp: Remove
unused function") to my tree.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
