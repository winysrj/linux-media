Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:1407 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbaIAHXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Sep 2014 03:23:55 -0400
Date: Mon, 1 Sep 2014 09:23:39 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jiri Kosina <trivial@kernel.org>
Cc: Antonio Ospite <ao2@ao2.it>, Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 01/12] trivial: drivers/media/usb/gspca/gspca.c: fix the
 indentation of a comment
Message-Id: <20140901092339.cc472cc46d480a1976ceeb72@ao2.it>
In-Reply-To: <1401883430-19492-2-git-send-email-ao2@ao2.it>
References: <1401883430-19492-1-git-send-email-ao2@ao2.it>
	<1401883430-19492-2-git-send-email-ao2@ao2.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed,  4 Jun 2014 14:03:39 +0200
Antonio Ospite <ao2@ao2.it> wrote:

> Fix indentation of a comment, put it on the same level of the code it
> refers to.
>
> Signed-off-by: Antonio Ospite <ao2@ao2.it>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Cc: linux-media@vger.kernel.org

Ping, I cannot see this in any upstream repository.
Here is the linux-media patchwork link:
https://patchwork.linuxtv.org/patch/24155/

Thanks,
   Antonio

> ---
>  drivers/media/usb/gspca/gspca.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index f3a7ace..f4bae98 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -870,9 +870,8 @@ static int gspca_init_transfer(struct gspca_dev *gspca_dev)
>  		ep_tb[0].alt = gspca_dev->alt;
>  		alt_idx = 1;
>  	} else {
> -
> -	/* else, compute the minimum bandwidth
> -	 * and build the endpoint table */
> +		/* else, compute the minimum bandwidth
> +		 * and build the endpoint table */
>  		alt_idx = build_isoc_ep_tb(gspca_dev, intf, ep_tb);
>  		if (alt_idx <= 0) {
>  			pr_err("no transfer endpoint found\n");
> -- 
> 2.0.0
> 
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
