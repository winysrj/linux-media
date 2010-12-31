Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48660 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab0LaGer (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 01:34:47 -0500
Date: Fri, 31 Dec 2010 09:34:33 +0300
From: Dan Carpenter <error27@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, devel@driverdev.osuosl.org,
	linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	linux-m68k@lists.linux-m68k.org,
	spi-devel-general@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 15/15]drivers:spi:dw_spi.c Typo change diable to
 disable.
Message-ID: <20101231063433.GB1886@bicker>
References: <1293750484-1161-6-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-7-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-8-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-9-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-10-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-11-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-12-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-13-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-14-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-15-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293750484-1161-15-git-send-email-justinmattock@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, Dec 30, 2010 at 03:08:04PM -0800, Justin P. Mattock wrote:
> The below patch fixes a typo "diable" to "disable". Please let me know if this
> is correct or not.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/spi/dw_spi.c |    6 +++---

You missed one from this file:

/* Set the interrupt mask, for poll mode just diable all int */
                                              ^^^^^^
regards,
dan carpenter

