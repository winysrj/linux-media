Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55258 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756372AbeDXKI5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 06:08:57 -0400
Date: Tue, 24 Apr 2018 13:08:55 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: davinci: don't override the error code
Message-ID: <20180424100855.77u5mwptaauepkqj@valkosipuli.retiisi.org.uk>
References: <f58d196d5d71450efab15afe01661923a3a7e28f.1524482537.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f58d196d5d71450efab15afe01661923a3a7e28f.1524482537.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 23, 2018 at 07:22:19AM -0400, Mauro Carvalho Chehab wrote:
> As warned by Coverity:
> 	CID 1415211 (#1 of 1): Unused value (UNUSED_VALUE)assigned_value:
> 	Assigning value -22 to ret here, but that stored value is
> 	overwritten before it can be used.
> 
> On all cases where the there's a goto 'unlock_out' or 'streamof',
> ret was filled with a non-sero value. It toesn't make sense to override
> such error code with a videobuf_streamoff() error.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
