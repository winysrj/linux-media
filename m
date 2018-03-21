Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52899 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753087AbeCUU1o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 16:27:44 -0400
Date: Wed, 21 Mar 2018 22:27:38 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] media: v4l2-common: fix a compilation breakage
Message-ID: <20180321202737.4p72qpbbq4iivqde@kekkonen.localdomain>
References: <238f694e1b7f8297f1256c57e41f69c39576c9b4.1521662907.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <238f694e1b7f8297f1256c57e41f69c39576c9b4.1521662907.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Mar 21, 2018 at 04:08:29PM -0400, Mauro Carvalho Chehab wrote:
> Clearly, changeset 95ce9c28601a ("media: v4l: common: Add a
> function to obtain best size from a list") was never tested, as it
> broke compilation with:
> 
> drivers/media/platform/vivid/vivid-vid-cap.c: In function ‘vivid_try_fmt_vid_cap’:
> drivers/media/platform/vivid/vivid-vid-cap.c:565:34: error: macro "v4l2_find_nearest_size" requer 6 argumentos, mas apenas 5 foram fornecidos
>              mp->width, mp->height);
>                                   ^
> drivers/media/platform/vivid/vivid-vid-cap.c:564:4: error: ‘v4l2_find_nearest_size’ undeclared (first use in this function); did you mean ‘__v4l2_find_nearest_size’?
>     v4l2_find_nearest_size(webcam_sizes, width, height,
>     ^~~~~~~~~~~~~~~~~~~~~~
>     __v4l2_find_nearest_size
> drivers/media/platform/vivid/vivid-vid-cap.c:564:4: note: each undeclared identifier is reported only once for each function it appears in
> drivers/media/i2c/ov5670.c: In function ‘ov5670_set_pad_format’:
> drivers/media/i2c/ov5670.c:2233:48: error: macro "v4l2_find_nearest_size" requer 6 argumentos, mas apenas 5 foram fornecidos
>            fmt->format.width, fmt->format.height);
>                                                 ^
> drivers/media/i2c/ov5670.c:2232:9: error: ‘v4l2_find_nearest_size’ undeclared (first use in this function); did you mean ‘__v4l2_find_nearest_size’?
>   mode = v4l2_find_nearest_size(supported_modes, width, height,
>          ^~~~~~~~~~~~~~~~~~~~~~
>          __v4l2_find_nearest_size
> drivers/media/i2c/ov13858.c: In function ‘ov13858_set_pad_format’:
> drivers/media/i2c/ov13858.c:1379:48: error: macro "v4l2_find_nearest_size" requer 6 argumentos, mas apenas 5 foram fornecidos
>            fmt->format.width, fmt->format.height);
>                                                 ^
> drivers/media/i2c/ov13858.c:1378:9: error: ‘v4l2_find_nearest_size’ undeclared (first use in this function); did you mean ‘__v4l2_find_nearest_size’?
>   mode = v4l2_find_nearest_size(supported_modes, width, height,
>          ^~~~~~~~~~~~~~~~~~~~~~
>          __v4l2_find_nearest_size
> drivers/media/i2c/ov13858.c:1378:9: note: each undeclared identifier is reported only once for each function it appears in
> 
> Basically, v4l2_find_nearest_size() callers pass 5 arguments,
> while its definition require 6 args.
> 
> Unfortunately, my build process was also broken, as it was reporting me that
> the compilation went fine:
> 
> 	$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='compile_checks' M=drivers/staging/media
> 	$ make ARCH=i386  CF=-D__CHECK_ENDIAN__ CONFIG_DEBUG_SECTION_MISMATCH=y C=1 W=1 CHECK='compile_checks' M=drivers/media
> 
> 	*** ERRORS ***
> 
> 	*** WARNINGS ***
> 	compilation succeeded
> 
> That was due to a change here to use of linux-log-diff script that
> provides a diffstat between the errors output. Somehow, the logic
> was missing some fatal errors.

Apologies for the above. This isn't still the intended way how things
should be; I'll send you a new patch to properly address this on top of
yours.

What happened was that I had the patches in two different environments and
I ended up picking the last four patches from the wrong one. :-P No errors
from kbuild made me think the patches were the right ones...

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
