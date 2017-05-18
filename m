Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41016
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754347AbdEROKQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 10:10:16 -0400
Date: Thu, 18 May 2017 11:10:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: alan@linux.intel.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 00/13] staging: media: atomisp queued up patches
Message-ID: <20170518111010.756a13c2@vento.lan>
In-Reply-To: <20170518135022.6069-1-gregkh@linuxfoundation.org>
References: <20170518135022.6069-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 May 2017 15:50:09 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> Hi Mauro,
> 
> Here's the set of accumulated atomisp staging patches that I had in my
> to-review mailbox.  After this, my queue is empty, the driver is all
> yours!

Thanks!

Alan, please let me know if you prefer if I don't apply any of
such patches, otherwise I should be merging them tomorrow ;)

> Good Luck! :)

Thanks!

Regards,
Mauro
> 
> thanks,
> 
> greg k-h
> 
> Avraham Shukron (3):
>   staging: media: atomisp: fixed sparse warnings
>   staging: media: atomisp: fixed coding style errors
>   staging: media: atomisp: fix coding style warnings
> 
> Dan Carpenter (2):
>   staging: media: atomisp: one char read beyond end of string
>   staging: media: atomisp: putting NULs in the wrong place
> 
> Fabrizio Perria (1):
>   staging: media: atomisp: Fix unnecessary initialization of static
> 
> Guru Das Srinagesh (2):
>   staging: media: atomisp: use logical AND, not bitwise
>   staging: media: atomisp: Make undeclared symbols static
> 
> Hans de Goede (1):
>   staging: media: atomisp: Fix -Werror=int-in-bool-context compile
>     errors
> 
> Joe Perches (1):
>   staging: media: atomisp: Add __printf validation and fix fallout
> 
> Manny Vindiola (1):
>   staging: media: atomisp: fix missing blank line coding style issue in
>     atomisp_tpg.c
> 
> Mauro Carvalho Chehab (1):
>   staging: media: atomisp: don't treat warnings as errors
> 
> Valentin Vidic (1):
>   staging: media: atomisp: drop unused qos variable
> 
>  drivers/staging/media/atomisp/i2c/Makefile         |   2 -
>  drivers/staging/media/atomisp/i2c/imx/Makefile     |   2 -
>  drivers/staging/media/atomisp/i2c/ov5693/Makefile  |   2 -
>  .../staging/media/atomisp/pci/atomisp2/Makefile    |   2 +-
>  .../atomisp/pci/atomisp2/atomisp_compat_css20.c    |   1 -
>  .../media/atomisp/pci/atomisp2/atomisp_fops.c      |  14 +-
>  .../media/atomisp/pci/atomisp2/atomisp_tpg.c       |   1 +
>  .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |   2 +-
>  .../css2400/hive_isp_css_include/math_support.h    |   6 +-
>  .../css2400/hive_isp_css_include/string_support.h  |   9 +-
>  .../isp/kernels/sdis/sdis_1.0/ia_css_sdis.host.c   |   6 +-
>  .../isp/kernels/sdis/sdis_2/ia_css_sdis2.host.c    |   2 +-
>  .../isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.c      |   2 +-
>  .../atomisp2/css2400/runtime/binary/src/binary.c   |   2 +-
>  .../css2400/runtime/debug/interface/ia_css_debug.h |   1 +
>  .../css2400/runtime/debug/src/ia_css_debug.c       |   6 +-
>  .../media/atomisp/pci/atomisp2/css2400/sh_css.c    |  19 +-
>  .../atomisp/pci/atomisp2/css2400/sh_css_mipi.c     |   2 +-
>  .../atomisp/pci/atomisp2/css2400/sh_css_params.c   |  10 +-
>  .../platform/intel-mid/atomisp_gmin_platform.c     | 210 +++++++++++----------
>  .../platform/intel-mid/intel_mid_pcihelpers.c      |  12 +-
>  21 files changed, 162 insertions(+), 151 deletions(-)
> 



Thanks,
Mauro
