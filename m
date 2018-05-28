Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:19158 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933626AbeE1TqM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 15:46:12 -0400
Date: Mon, 28 May 2018 22:46:09 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: imx258: get rid of an unused var
Message-ID: <20180528194609.vk2mrwdjmkreesay@kekkonen.localdomain>
References: <66a1e187a88fcceb84a390e6ea0c35e9f7a7f252.1527530230.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66a1e187a88fcceb84a390e6ea0c35e9f7a7f252.1527530230.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 28, 2018 at 01:57:11PM -0400, Mauro Carvalho Chehab wrote:
> drivers/media/i2c/imx258.c: In function 'imx258_init_controls':
> drivers/media/i2c/imx258.c:1117:6: warning: variable 'exposure_max' set but not used [-Wunused-but-set-variable]
>   s64 exposure_max;
>       ^~~~~~~~~~~~
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
