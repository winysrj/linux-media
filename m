Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:30451 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaIAHb5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:57 -0400
Date: Mon, 1 Sep 2014 09:26:26 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jiri Kosina <trivial@kernel.org>
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 02/12] trivial: drivers/media/usb/gspca/gspca.h: indent
 with TABs, not spaces
Message-Id: <20140901092626.31ca8039f328a13103365c58@ao2.it>
In-Reply-To: <1401883430-19492-3-git-send-email-ao2@ao2.it>
References: <1401883430-19492-1-git-send-email-ao2@ao2.it>
	<1401883430-19492-3-git-send-email-ao2@ao2.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed,  4 Jun 2014 14:03:40 +0200
Antonio Ospite <ao2@ao2.it> wrote:

> Signed-off-by: Antonio Ospite <ao2@ao2.it>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: linux-media@vger.kernel.org

Ping.
linux-media patchwork link:
https://patchwork.linuxtv.org/patch/24156/

Thanks,
   Antonio

> ---
>  drivers/media/usb/gspca/gspca.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
> index 300642d..c1273e5 100644
> --- a/drivers/media/usb/gspca/gspca.h
> +++ b/drivers/media/usb/gspca/gspca.h
> @@ -234,6 +234,6 @@ int gspca_resume(struct usb_interface *intf);
>  int gspca_expo_autogain(struct gspca_dev *gspca_dev, int avg_lum,
>  	int desired_avg_lum, int deadzone, int gain_knee, int exposure_knee);
>  int gspca_coarse_grained_expo_autogain(struct gspca_dev *gspca_dev,
> -        int avg_lum, int desired_avg_lum, int deadzone);
> +	int avg_lum, int desired_avg_lum, int deadzone);
>  
>  #endif /* GSPCAV2_H */
> -- 
> 2.0.0
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
