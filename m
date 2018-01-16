Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:14301 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751504AbeAPWtt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 17:49:49 -0500
Date: Wed, 17 Jan 2018 00:49:45 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v4] media: s3c-camif: fix out-of-bounds array access
Message-ID: <20180116224944.sjh4trlc7ewyjsyi@kekkonen.localdomain>
References: <20180116215242.784423-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180116215242.784423-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 16, 2018 at 10:52:15PM +0100, Arnd Bergmann wrote:
> While experimenting with older compiler versions, I ran
> into a warning that no longer shows up on gcc-4.8 or newer:
> 
> drivers/media/platform/s3c-camif/camif-capture.c: In function '__camif_subdev_try_format':
> drivers/media/platform/s3c-camif/camif-capture.c:1265:25: error: array subscript is below array bounds
> 
> This is an off-by-one bug, leading to an access before the start of the
> array, while newer compilers silently assume this undefined behavior
> cannot happen and leave the loop at index 0 if no other entry matches.
> 
> As Sylvester explains, we actually need to ensure that the
> value is within the range, so this reworks the loop to be
> easier to parse correctly, and an additional check to fall
> back on the first format value for any unexpected input.
> 
> I found an existing gcc bug for it and added a reduced version
> of the function there.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=69249#c3
> Fixes: babde1c243b2 ("[media] V4L: Add driver for S3C24XX/S3C64XX SoC series camera interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
