Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46870 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965780AbcA1Aen (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 19:34:43 -0500
Date: Thu, 28 Jan 2016 02:34:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: Fix media_open() to clear filp->private_data in
 error leg
Message-ID: <20160128003438.GK14876@valkosipuli.retiisi.org.uk>
References: <1453938573-13093-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453938573-13093-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 27, 2016 at 04:49:33PM -0700, Shuah Khan wrote:
> Fix media_open() to clear filp->private_data when file open
> fails.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
