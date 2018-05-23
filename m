Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:32838 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754378AbeEWJ1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 05:27:34 -0400
Date: Wed, 23 May 2018 12:27:30 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
Cc: alan@linux.intel.com, mchehab@kernel.org,
        gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Fix issues reported by static analysis tool.
Message-ID: <20180523092730.va7ds7t6h3zhyz7r@paasikivi.fi.intel.com>
References: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pankaj,

On Wed, May 23, 2018 at 10:51:30AM +0530, Pankaj Bharadiya wrote:
> This patch series fixes some of the issues reported by static analysis
> tool.
> 
> Pankaj Bharadiya (6):
>   media: staging: atomisp: remove redundent check
>   media: staging: atomisp: Remove useless if statement
>   media: staging: atomisp: Remove useless "ifndef ISP2401"
>   media: staging: atomisp: Fix potential NULL pointer dereference
>   media: staging: atomisp: Fix potential NULL pointer dereference
>   media: staging: atomisp: Fix potential NULL pointer dereference
> 
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c   | 14 --------------
>  .../media/atomisp/pci/atomisp2/atomisp_compat_css20.c      |  2 --
>  drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c  |  8 --------
>  .../pci/atomisp2/css2400/camera/pipe/src/pipe_binarydesc.c |  3 ++-
>  .../staging/media/atomisp/pci/atomisp2/css2400/sh_css.c    |  7 +++++--
>  5 files changed, 7 insertions(+), 27 deletions(-)
> 

I'm sorry to tell you that the atomisp driver was removed from the staging
tree some time ago.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
