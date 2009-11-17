Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:53333 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZKQJva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 04:51:30 -0500
Date: Tue, 17 Nov 2009 10:51:44 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] gspca: add sanity check for mandatory operations
Message-ID: <20091117105144.70ee9550@tele>
In-Reply-To: <4B02470C.7000205@freemail.hu>
References: <4B02470C.7000205@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Nov 2009 07:47:40 +0100
Németh Márton <nm127@freemail.hu> wrote:

> From: Márton Németh <nm127@fremail.hu>
> 
> Add check for the mandatory config, init, start and pkt_scan
> gspca subdriver operations.
> 
> Signed-off-by: Márton Németh <nm127@fremail.hu>
> ---
> diff -r 182b5f8fa160 linux/drivers/media/video/gspca/gspca.c
> --- a/linux/drivers/media/video/gspca/gspca.c	Sun Nov 15
> 10:05:30 2009 +0100 +++
> b/linux/drivers/media/video/gspca/gspca.c	Tue Nov 17 07:42:34
> 2009 +0100 @@ -2035,6 +2035,12 @@ return -ENODEV;
>  	}
> 
> +	/* check for mandatory operations */
> +	BUG_ON(!sd_desc->config);
> +	BUG_ON(!sd_desc->init);
> +	BUG_ON(!sd_desc->start);
> +	BUG_ON(!sd_desc->pkt_scan);
> +
>  	/* create the device */
>  	if (dev_size < sizeof *gspca_dev)
>  		dev_size = sizeof *gspca_dev;

Hi Németh,

I don't think this is useful: the people who write the subdrivers know
the mandatory parameters. If not, the system will simply oops at the
first test...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
