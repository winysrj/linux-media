Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42070 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752033AbdHIIPO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Aug 2017 04:15:14 -0400
Date: Wed, 9 Aug 2017 11:15:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Yang, Hyungwoo" <hyungwoo.yang@intel.com>,
        "Rapolu, Chiranjeevi" <chiranjeevi.rapolu@intel.com>
Subject: Re: [PATCH -next] media: ov5670: add depends to fix build errors
Message-ID: <20170809081512.w2qc2vvnalyki4c5@valkosipuli.retiisi.org.uk>
References: <7b6d824a-2574-d33f-7bc9-308809b15b70@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b6d824a-2574-d33f-7bc9-308809b15b70@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 20, 2017 at 04:47:38PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix build errors by adding dependency on VIDEO_V4L2_SUBDEV_API:

Thanks for the patch, Randy, but I've already applied Arnd's patch with
very similar content.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
