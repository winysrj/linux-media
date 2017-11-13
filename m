Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:13689 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753175AbdKMWFw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Nov 2017 17:05:52 -0500
Date: Tue, 14 Nov 2017 00:05:48 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Alan <alan@linux.intel.com>
Cc: vincent.hervieux@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] atomisp: fix vfree of bogus data on unload
Message-ID: <20171113220548.ji4z4e5neehxg4wn@kekkonen.localdomain>
References: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
 <151001140261.77201.8823780763771880199.stgit@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151001140261.77201.8823780763771880199.stgit@alans-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Mon, Nov 06, 2017 at 11:36:45PM +0000, Alan wrote:
> We load the firmware once, set pointers to it and then at some point release
> it. We should not be doing a vfree() on the pointers into the firmware.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> index 8158ea40d069..f181bd8fcee2 100644
> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> @@ -288,8 +288,6 @@ void sh_css_unload_firmware(void)
>  		for (i = 0; i < sh_css_num_binaries; i++) {
>  			if (fw_minibuffer[i].name)
>  				kfree((void *)fw_minibuffer[i].name);
> -			if (fw_minibuffer[i].buffer)
> -				vfree((void *)fw_minibuffer[i].buffer);

You shouldn't end up here if the firmware is just loaded once. If multiple
times, then yes.

The memory appears to have been allocated using kmalloc() in some cases.
How about kvfree(), or changing that kmalloc() to vmalloc()?

>  		}
>  		kfree(fw_minibuffer);
>  		fw_minibuffer = NULL;
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
