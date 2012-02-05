Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50578 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2BEJNK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 04:13:10 -0500
Date: Sun, 5 Feb 2012 11:13:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH v2 2/2] v4l2: add new pixel formats supported on dm365
Message-ID: <20120205091306.GC7784@valkosipuli.localdomain>
References: <1327065739-3362-1-git-send-email-manjunath.hadli@ti.com>
 <1327065739-3362-3-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327065739-3362-3-git-send-email-manjunath.hadli@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On Fri, Jan 20, 2012 at 06:52:19PM +0530, Manjunath Hadli wrote:
> add new macro V4L2_PIX_FMT_SGRBG10ALAW8 and associated formats
> to represent Bayer format frames compressed by A-LAW alogorithm,
> add V4L2_PIX_FMT_UV8 to represent storage of C data (UV interleved)
> only.

The patch is finally here:

<URL:http://www.spinics.net/lists/linux-media/msg43890.html>

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
