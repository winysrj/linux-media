Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58176 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750996AbbCMLHT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 07:07:19 -0400
Date: Fri, 13 Mar 2015 13:07:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] DocBook media: fix PIX_FMT_SGRBR8 example
Message-ID: <20150313110715.GS11954@valkosipuli.retiisi.org.uk>
References: <5502C335.4080501@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5502C335.4080501@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 13, 2015 at 12:00:05PM +0100, Hans Verkuil wrote:
> Fix the example of the V4L2_PIX_FMT_SGRBG8 Bayer format.
> 
> The even lines should read BGBG, not RBRB.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
