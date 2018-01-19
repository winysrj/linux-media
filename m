Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50446 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755809AbeASRLD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Jan 2018 12:11:03 -0500
Date: Fri, 19 Jan 2018 19:11:00 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: mchehab@kernel.org, arnd@arndb.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: v4l: omap_vout: vrfb: Use the wrapper for
 prep_interleaved_dma()
Message-ID: <20180119171059.p3o4pihea6hcrg7y@valkosipuli.retiisi.org.uk>
References: <20180119133434.3587-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180119133434.3587-1-peter.ujfalusi@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Peter! :-)

How do you do?

On Fri, Jan 19, 2018 at 03:34:34PM +0200, Peter Ujfalusi wrote:
> Instead of directly accessing to dmadev->device_prep_interleaved_dma() use
> the dmaengine_prep_interleaved_dma() wrapper instead.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
