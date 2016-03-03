Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756753AbcCCPng (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 10:43:36 -0500
Date: Thu, 3 Mar 2016 21:17:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: maxime.ripard@free-electrons.com, wens@csie.org,
	mchehab@osg.samsung.com, balbi@kernel.org, hdegoede@redhat.com,
	dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Emilio =?iso-8859-1?Q?L=F3pez?= <emilio.lopez@collabora.co.uk>
Subject: Re: [PATCH 2/3] dmaengine: sun4i: support module autoloading
Message-ID: <20160303154735.GR11154@localhost>
References: <1456104396-13282-1-git-send-email-emilio@elopez.com.ar>
 <1456104396-13282-2-git-send-email-emilio@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1456104396-13282-2-git-send-email-emilio@elopez.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 21, 2016 at 10:26:35PM -0300, Emilio López wrote:
> From: Emilio López <emilio.lopez@collabora.co.uk>
> 
> MODULE_DEVICE_TABLE() is missing, so the module isn't auto-loading on
> supported systems. This commit adds the missing line so it loads
> automatically when building it as a module and running on a system
> with the early sunxi DMA engine.

Applied, thanks

-- 
~Vinod
