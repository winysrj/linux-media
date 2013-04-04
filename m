Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37670 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759877Ab3DDNHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Apr 2013 09:07:32 -0400
Date: Thu, 4 Apr 2013 16:07:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] omap3isp: Use the common clock framework
Message-ID: <20130404130727.GH10541@valkosipuli.retiisi.org.uk>
References: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1365073719-8038-2-git-send-email-laurent.pinchart@ideasonboard.com>
 <20130404112004.GG10541@valkosipuli.retiisi.org.uk>
 <515D63A4.2060108@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515D63A4.2060108@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Apr 04, 2013 at 01:27:32PM +0200, Sylwester Nawrocki wrote:
> clkdev_drop() will free memory allocated here. So using devm_kzalloc()
> wouldn't be correct.

Thanks for pointing this out. I should educate myself on the common clock
framework. The problem, though, is where to get the time for that. :-P

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
