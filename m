Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36036 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753778AbdEHUzh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 8 May 2017 16:55:37 -0400
Date: Mon, 8 May 2017 23:55:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Rajmohan Mani <rajmohan.mani@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v2] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170508205532.GM7456@valkosipuli.retiisi.org.uk>
References: <1494254208-30045-1-git-send-email-rajmohan.mani@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494254208-30045-1-git-send-email-rajmohan.mani@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 08, 2017 at 07:36:48AM -0700, Rajmohan Mani wrote:
> +	dev_dbg(dev, "%s ret = %d\n", __func__, ret);

Please remove such debug prints.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
