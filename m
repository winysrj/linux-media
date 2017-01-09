Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49681 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758832AbdAIKcr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 05:32:47 -0500
Date: Mon, 9 Jan 2017 13:30:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/8] [media] videobuf-dma-sg: Adjust 24 checks for null
 values
Message-ID: <20170109103020.GB4239@mwanda>
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
 <7b963ec7-1ec7-5e44-e9ff-9385bc41aa48@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b963ec7-1ec7-5e44-e9ff-9385bc41aa48@users.sourceforge.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 26, 2016 at 09:48:19PM +0100, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 26 Dec 2016 20:30:19 +0100
> 
> Convert comparisons with the preprocessor symbol "NULL" or the value "0"
> to condition checks without it.

Generally lengths are numbers and not booleans so "len == 0" is ok.
Checkpatch doesn't complain about that.

regards,
dan carpenter


