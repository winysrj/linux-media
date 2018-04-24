Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55228 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757009AbeDXKI1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:08:27 -0400
Date: Tue, 24 Apr 2018 13:08:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: em28xx: Don't use ops->resume if NULL
Message-ID: <20180424100825.vasvpblqwxnquafs@valkosipuli.retiisi.org.uk>
References: <875ca4eae7623e3f54acb2fd364404491b78951d.1524481357.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875ca4eae7623e3f54acb2fd364404491b78951d.1524481357.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 07:02:39AM -0400, Mauro Carvalho Chehab wrote:
> Changeset  be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD
> second tuner functionality") introduced a potential NULL pointer
> dereference, as pointed by Coverity:
> 
> CID 1434731 (#1 of 1): Dereference after null check (FORWARD_NULL)16. var_deref_op: Dereferencing null pointer ops->resume.
> 
> var_compare_op: Comparing ops->resume to null implies that ops->resume might be null.
> 1174                if (ops->resume)
> 1175                        ops->resume(dev);
> 1176                if (dev->dev_next)
> 1177                        ops->resume(dev->dev_next);
> 
> Fixes: be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner functionality")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
