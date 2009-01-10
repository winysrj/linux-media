Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:1311 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZAJJmy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 04:42:54 -0500
Date: Sat, 10 Jan 2009 10:42:26 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	V4L and DVB maintainers <v4l-dvb-maintainer@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: zr36067 no longer loads automatically (regression)
Message-ID: <20090110104226.7289e69a@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0901091215100.1626@shell2.speakeasy.net>
References: <20090108143315.2b564dfe@hyperion.delvare>
	<20090108175627.0ebd9f36@pedra.chehab.org>
	<Pine.LNX.4.58.0901081319340.1626@shell2.speakeasy.net>
	<20090108193923.580fcd5b@pedra.chehab.org>
	<Pine.LNX.4.58.0901082156270.1626@shell2.speakeasy.net>
	<20090109092018.59a6d9eb@pedra.chehab.org>
	<20090109124357.549acef6@hyperion.delvare>
	<Pine.LNX.4.58.0901091112590.1626@shell2.speakeasy.net>
	<Pine.LNX.4.58.0901091215100.1626@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Trent,

On Fri, 9 Jan 2009 12:20:54 -0800 (PST), Trent Piepho wrote:
> On Fri, 9 Jan 2009, Trent Piepho wrote:
> > Here is a new version against latest v4l-dvb sources.  Jean, are you trying
> > to apply against the kernel tree?  These patches are against the v4l-dvb Hg
> > repository which isn't quite the same as what's in the kernel.
> >
> > I have some more patches at http://linuxtv.org/hg/~tap/zoran
> 
> Forgot the patch

Patch tested successfully. Nice cleanup! I wanted to do it for quite
some time but could never find the time.

Acked-by: Jean Delvare <khali@linux-fr.org>

With just one suggestion:

> (...)
> +static int __init zoran_init(void)
>  {
>  	int i;
> 
> (...)
> +	i = pci_register_driver(&zoran_driver);
> +	if (i) {
> +		dprintk(1,
> +			KERN_ERR
> +			"%s: Unable to register ZR36057 driver\n",
> +			ZORAN_NAME);
> +		return i;

"i" could be renamed to "err" for clarity.

>  	}
> 
>  	return 0;
>  }

Thanks,
-- 
Jean Delvare
