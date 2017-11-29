Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33184 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752099AbdK2IsJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 03:48:09 -0500
Date: Wed, 29 Nov 2017 10:48:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2 0/3] Sparse fixes for the Atom ISP Staging Driver
Message-ID: <20171129084807.oahjg2ucyjyhafkc@valkosipuli.retiisi.org.uk>
References: <20171127190938.73c6b15a@alans-desktop>
 <20171128102726.30542-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128102726.30542-1-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 28, 2017 at 10:27:24AM +0000, Jeremy Sowden wrote:
> Fixed some sparse warnings in the Atom ISP staging driver.
> 
> This time with longer commit messages. :)
> 
> I've chosen to ignore checkpatch.pl's suggestion to change the types of
> the arrays in the second patch from int16_t to s16.
> 
> Jeremy Sowden (2):
>   media: staging: atomisp: fix for sparse "using plain integer as NULL
>     pointer" warnings.
>   media: staging: atomisp: fixes for "symbol was not declared. Should it
>     be static?" sparse warnings.
> 
>  .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 24 +++++++++++-----------
>  .../isp_param/interface/ia_css_isp_param_types.h   |  2 +-
>  2 files changed, 13 insertions(+), 13 deletions(-)

Thanks, applied!

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
