Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37354 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1762537AbdLSL4m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 06:56:42 -0500
Date: Tue, 19 Dec 2017 13:56:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 15/24] media: v4l2-subdev: get rid of
 __V4L2_SUBDEV_MK_GET_TRY() macro
Message-ID: <20171219115627.rs67wfc4qfnjzzzx@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <63937cedcefd1c56b211ec115b717510c470bd1a.1507544011.git.mchehab@s-opensource.com>
 <20171009202355.ckhaf5xcba5z4tvh@valkosipuli.retiisi.org.uk>
 <20171218172704.57d250d0@vento.lan>
 <20171219082450.csf4hwlhmpe52xly@valkosipuli.retiisi.org.uk>
 <20171219090355.6f9a36e2@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171219090355.6f9a36e2@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 19, 2017 at 09:03:55AM -0200, Mauro Carvalho Chehab wrote:
> [PATCH] media: v4l2-subdev: get rid of __V4L2_SUBDEV_MK_GET_TRY() macro
> 
> The __V4L2_SUBDEV_MK_GET_TRY() macro is used to define
> 3 functions that have the same arguments. The code of those
> functions is simple enough to just declare them, de-obfuscating
> the code.
> 
> While here, replace BUG_ON() by WARN_ON() as there's no reason
> why to panic the Kernel if this fails.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
