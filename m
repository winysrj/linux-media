Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:41950 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751663AbdH2JJu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 05:09:50 -0400
Message-ID: <1503997786.2040.23.camel@perches.com>
Subject: Re: [PATCH 4/4] [media] zr364xx: Fix a typo in a comment line of
 the file header
From: Joe Perches <joe@perches.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Date: Tue, 29 Aug 2017 02:09:46 -0700
In-Reply-To: <bea45b65-dd34-73a6-cfd7-2ce22aa749fe@users.sourceforge.net>
References: <d632eadf-98a3-7e05-4d9d-96d04b3619ff@users.sourceforge.net>
         <bea45b65-dd34-73a6-cfd7-2ce22aa749fe@users.sourceforge.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2017-08-29 at 07:35 +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 28 Aug 2017 22:46:30 +0200
> 
> Fix a word in this description.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/usb/zr364xx/zr364xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
> index 4cc6d2a9d91f..4ccf71d8b608 100644
> --- a/drivers/media/usb/zr364xx/zr364xx.c
> +++ b/drivers/media/usb/zr364xx/zr364xx.c
> @@ -2,7 +2,7 @@
>   * Zoran 364xx based USB webcam module version 0.73
>   *
>   * Allows you to use your USB webcam with V4L2 applications
> - * This is still in heavy developpement !
> + * This is still in heavy development!

There is almost no development being done here.
Just delete the line.
