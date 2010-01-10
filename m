Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56023 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0AJPMm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 10:12:42 -0500
Message-ID: <4B49EE5E.9040904@s5r6.in-berlin.de>
Date: Sun, 10 Jan 2010 16:12:30 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4l/dvb] firedtv: add forgotten __exit annotation
References: <tkrat.c98a9e80d83e315a@s5r6.in-berlin.de>
In-Reply-To: <tkrat.c98a9e80d83e315a@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote on 2009-12-26:
> fdtv_fw_exit() is part of the firedtv driver's .exit.text section.
...
> --- linux-2.6.33-rc2.orig/drivers/media/dvb/firewire/firedtv-fw.c
> +++ linux-2.6.33-rc2/drivers/media/dvb/firewire/firedtv-fw.c
> @@ -332,7 +332,7 @@ int __init fdtv_fw_init(void)
>  	return driver_register(&fdtv_driver.driver);
>  }
>  
> -void fdtv_fw_exit(void)
> +void __exit fdtv_fw_exit(void)
>  {
>  	driver_unregister(&fdtv_driver.driver);
>  	fw_core_remove_address_handler(&fcp_handler);
> 

This patch is bogus.  fdtv_fw_exit() is also called from firedtv's init.
-- 
Stefan Richter
-=====-==-=- ---= -=-=-
http://arcgraph.de/sr/
