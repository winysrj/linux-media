Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34331 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751177AbaIDHJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 03:09:26 -0400
Date: Thu, 4 Sep 2014 10:08:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	Daniel Jeong <gshark.jeong@gmail.com>
Subject: Re: [PATCH 28/46] [media] lm3560: simplify boolean tests
Message-ID: <20140904070852.GK30024@valkosipuli.retiisi.org.uk>
References: <cover.1409775488.git.m.chehab@samsung.com>
 <4e97984ba765f3811f32615b388e698e699b34af.1409775488.git.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e97984ba765f3811f32615b388e698e699b34af.1409775488.git.m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 03, 2014 at 05:33:00PM -0300, Mauro Carvalho Chehab wrote:
> Instead of using if (on == true), just use
> if (on).
> 
> That allows a faster mental parsing when analyzing the
> code.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
