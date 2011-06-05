Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:37645 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab1FEMLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jun 2011 08:11:34 -0400
Date: Sun, 5 Jun 2011 15:11:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "HeungJun, Kim" <riverful.kim@samsung.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 3/4] m5mols: remove union in the
 m5mols_get_version(), and VERSION_SIZE
Message-ID: <20110605121129.GE6073@valkosipuli.localdomain>
References: <1306501095-28267-1-git-send-email-riverful.kim@samsung.com>
 <1306827362-4064-4-git-send-email-riverful.kim@samsung.com>
 <20110605120347.GD6073@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605120347.GD6073@valkosipuli.localdomain>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Jun 05, 2011 at 03:03:47PM +0300, Sakari Ailus wrote:
[clip]
> > -	/* store version information swapped for being readable */
> > -	info->ver	= version.ver;
> >  	info->ver.fw	= be16_to_cpu(info->ver.fw);
> >  	info->ver.hw	= be16_to_cpu(info->ver.hw);
> >  	info->ver.param	= be16_to_cpu(info->ver.param);
> 
> As you have a local variable ver pointing to info->ver, you should also use
> it here.

With this change,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
