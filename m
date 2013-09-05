Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33813 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753358Ab3IEUtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Sep 2013 16:49:35 -0400
Date: Thu, 5 Sep 2013 23:49:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Christoph Jaeger <christophjaeger@linux.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: dvb-frontends: Remove unused SIZEOF_ARRAY
Message-ID: <20130905204930.GG4493@valkosipuli.retiisi.org.uk>
References: <1377977467-28647-1-git-send-email-christophjaeger@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377977467-28647-1-git-send-email-christophjaeger@linux.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 31, 2013 at 09:31:07PM +0200, Christoph Jaeger wrote:
> SIZEOF_ARRAY is not used (anymore). Besides, ARRAY_SIZE, defined in
> include/linux/kernel.h, should be used rather than explicitly coding some
> variant of it.
> 
> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>

Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
