Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59310 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751661AbeAWNCH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 08:02:07 -0500
Date: Tue, 23 Jan 2018 15:02:05 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH] media: dw9714: annotate a __be16 integer value
Message-ID: <20180123130205.o472hax6dmrdz63g@valkosipuli.retiisi.org.uk>
References: <e139bd217bdb250b63e6359bf16e67fb232c9aa2.1516712231.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e139bd217bdb250b63e6359bf16e67fb232c9aa2.1516712231.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Jan 23, 2018 at 07:57:14AM -0500, Mauro Carvalho Chehab wrote:
> As warned:
>    drivers/media/i2c/dw9714.c: warning: incorrect type in initializer (different base types):  => 64:19
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
