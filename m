Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44966 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756160AbeEIJ5V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 05:57:21 -0400
Date: Wed, 9 May 2018 12:57:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>
Subject: Re: [PATCH] media: video-i2c: get rid of two gcc warnings
Message-ID: <20180509095718.gux7v4hsoxebc4kc@valkosipuli.retiisi.org.uk>
References: <1b3d5f2ae882cfca37c4422dfd72fd455d01166a.1525443571.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b3d5f2ae882cfca37c4422dfd72fd455d01166a.1525443571.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 04, 2018 at 10:19:34AM -0400, Mauro Carvalho Chehab wrote:
> After adding this driver, gcc complains with:
> 
> drivers/media/i2c/video-i2c.c:55:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
>  const static struct v4l2_fmtdesc amg88xx_format = {
>  ^~~~~
> drivers/media/i2c/video-i2c.c:59:1: warning: 'static' is not at beginning of declaration [-Wold-style-declaration]
>  const static struct v4l2_frmsize_discrete amg88xx_size = {
>  ^~~~~
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
