Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22635 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZIKMAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 08:00:01 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8BBxn1e019331
	for <linux-media@vger.kernel.org>; Fri, 11 Sep 2009 14:59:51 +0300
Date: Fri, 11 Sep 2009 14:45:28 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "Aaltonen Matti.J (Nokia-D/Tampere)" <matti.j.aaltonen@nokia.com>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: [PATCH 1/1] FM TX: si4713: Kconfig: Fixed two typos.
Message-ID: <20090911114528.GA4715@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-4-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-5-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-6-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-7-git-send-email-eduardo.valentin@nokia.com>
 <1249729833-24975-8-git-send-email-eduardo.valentin@nokia.com>
 <1252654684.19083.140.camel@masi.ntc.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252654684.19083.140.camel@masi.ntc.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 11, 2009 at 09:38:04AM +0200, Aaltonen Matti.J (Nokia-D/Tampere) wrote:
> Fixed two typos.
> 
> Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>

Acked-by: Eduardo Valentin <eduardo.valentin@nokia.com>

> 
> diff -r 5582a6427a41 -r ff80edccfe24 linux/drivers/media/radio/Kconfig
> --- a/linux/drivers/media/radio/Kconfig	Tue Sep 01 22:16:23 2009 +0200
> +++ b/linux/drivers/media/radio/Kconfig	Fri Sep 11 10:25:13 2009 +0300
> @@ -346,7 +346,7 @@
>  	---help---
>  	  Say Y here if you want support to Si4713 FM Radio Transmitter.
>  	  This device can transmit audio through FM. It can transmit
> -	  EDS and EBDS signals as well. This module is the v4l2 radio
> +	  RDS and RBDS signals as well. This module is the v4l2 radio
>  	  interface for the i2c driver of this device.
>  
>  	  To compile this driver as a module, choose M here: the
> 

-- 
Eduardo Valentin
