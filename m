Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f29.google.com ([209.85.218.29]:41589 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbZATDdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 22:33:43 -0500
Received: by bwz10 with SMTP id 10so2050693bwz.13
        for <linux-media@vger.kernel.org>; Mon, 19 Jan 2009 19:33:40 -0800 (PST)
Subject: Re: [PATCH] Add support for sq905 based cameras to gspca
From: Alexey Klimov <klimov.linux@gmail.com>
To: Adam Baker <linux@baker-net.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
	kilgota@banach.math.auburn.edu,
	Driver Development <sqcam-devel@lists.sourceforge.net>
In-Reply-To: <200901192322.33362.linux@baker-net.org.uk>
References: <200901192322.33362.linux@baker-net.org.uk>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 06:33:51 +0300
Message-Id: <1232422431.28984.10.camel@tux.localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Adam
May i add small note if you don't mind ?

On Mon, 2009-01-19 at 23:22 +0000, Adam Baker wrote:

<snip>

> +/* -- module insert / remove -- */
> +static int __init sd_mod_init(void)
> +{
> +	if (usb_register(&sd_driver) < 0)
> +		return -1;
> +	PDEBUG(D_PROBE, "registered");
> +	return 0;
> +}
> +static void __exit sd_mod_exit(void)
> +{
> +	usb_deregister(&sd_driver);
> +	PDEBUG(D_PROBE, "deregistered");
> +}

May be it's better for CodingStyle if sd_mod_init will look like this:

static int __init sd_mod_init(void) 
{ 
	int ret; 
	ret = usb_register(&sd_driver); 
	if (ret < 0) 
		return ret; 
	PDEBUG(D_PROBE, "registered"); 
	return 0; 
}

?


> +module_init(sd_mod_init);
> +module_exit(sd_mod_exit);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Best regards, Klimov Alexey

