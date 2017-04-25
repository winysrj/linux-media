Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19689 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945410AbdDYM5x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 08:57:53 -0400
Date: Tue, 25 Apr 2017 15:57:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] vb2: Fix an off by one error in
 'vb2_plane_vaddr'
Message-ID: <20170425125723.6otfxmhkh3igtaqm@mwanda>
References: <20170423213257.14773-1-christophe.jaillet@wanadoo.fr>
 <20170424141655.GQ7456@valkosipuli.retiisi.org.uk>
 <9aab41eb-5543-58d2-211f-95fb00f5176c@wanadoo.fr>
 <20170424202906.GW7456@valkosipuli.retiisi.org.uk>
 <09a88460-39fc-7d80-e213-15e47499319d@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09a88460-39fc-7d80-e213-15e47499319d@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gar... No.  The 3.6+ from a9ae4692eda4 ("[media] vb2: fix plane index
sanity check in vb2_plane_cookie()") feels totally arbitrary to me.  No
need to be consistent.

Just do:

Cc: stable@vger.kernel.org
Fixes: e23ccc0ad925 ("[media] v4l: add videobuf2 Video for Linux 2 driver framework")

Fixes tags are always good too have btw.  You should be adding them
by default to everything even if it doesn't get backported to stable.

regards,
dan carpenter
