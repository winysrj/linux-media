Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0172.hostedemail.com ([216.40.44.172]:33105 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752784Ab3K0DVU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 22:21:20 -0500
Message-ID: <1385522475.18487.34.camel@joe-AO722>
Subject: Re: [PATCH] drivers: staging: media: go7007: go7007-usb.c use
 pr_*() instead of dev_*() before 'go' initialized in go7007_usb_probe()
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: hans.verkuil@cisco.com, m.chehab@samsung.com,
	rkuo <rkuo@codeaurora.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Tue, 26 Nov 2013 19:21:15 -0800
In-Reply-To: <52956442.50001@gmail.com>
References: <528AEFB7.4060301@gmail.com>
	 <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>
	 <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
	 <52956442.50001@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2013-11-27 at 11:17 +0800, Chen Gang wrote:
> dev_*() assumes 'go' is already initialized, so need use pr_*() instead
> of before 'go' initialized.
[]
> diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
[]
> @@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
>  	char *name;
>  	int video_pipe, i, v_urb_len;
>  
> -	dev_dbg(go->dev, "probing new GO7007 USB board\n");
> +	pr_devel("probing new GO7007 USB board\n");

pr_devel is commonly compiled out completely unless DEBUG is #defined.
You probably want to use pr_debug here.
 

