Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39107 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbdJPONe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 10:13:34 -0400
Date: Mon, 16 Oct 2017 17:13:31 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] stk-webcam: Fix use after free on disconnect
Message-ID: <20171016141331.qyjzz26l567ycdew@paasikivi.fi.intel.com>
References: <CAAeHK+yQshGzduWP-hpGbbnYh9uHbeODDsEX_K3KmgaNXHNFNQ@mail.gmail.com>
 <20170922134841.kxfwwn2yocjgnuad@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170922134841.kxfwwn2yocjgnuad@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 22, 2017 at 04:48:41PM +0300, Dan Carpenter wrote:
> We free the stk_camera device too early.  It's allocate first in probe
> and it should be freed last in stk_camera_disconnect().
> 
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Not tested but these bug reports seem surprisingly straight forward.
> Thanks Andrey!

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
