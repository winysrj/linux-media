Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52998 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756001AbcCCHdc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Mar 2016 02:33:32 -0500
Date: Thu, 3 Mar 2016 09:33:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH for 4.5] media.h: use hex values for the range offsets,
 move connectors base up.
Message-ID: <20160303073326.GI11084@valkosipuli.retiisi.org.uk>
References: <56D3FB27.7000202@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56D3FB27.7000202@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Feb 29, 2016 at 09:02:47AM +0100, Hans Verkuil wrote:
> Make the base offset hexadecimal to simplify debugging since the base
> addresses are hex too.
> 
> The offsets for connectors is also changed to start after the 'reserved'
> range 0x10000-0x2ffff.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
