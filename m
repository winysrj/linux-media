Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:49057 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZFRVBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 17:01:00 -0400
Date: Thu, 18 Jun 2009 14:00:50 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jan Nikitenko <jan.nikitenko@gmail.com>
cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] af9015: avoid magically sized temporal buffer in
 eeprom_dump
In-Reply-To: <20090618112227.GA9930@nikitenko.systek.local>
Message-ID: <Pine.LNX.4.58.0906181358390.32713@shell2.speakeasy.net>
References: <c4bc83220906091531h20677733kd993ed50c0bc74ec@mail.gmail.com>
 <4A2EF922.5040102@iki.fi> <20090618111253.GC9575@nikitenko.systek.local>
 <20090618112227.GA9930@nikitenko.systek.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Jun 2009, Jan Nikitenko wrote:
> Replace printing to magically sized temporal buffer with use of KERN_CONT

temporary not temporal.

> -			sprintf(buf2, "%02x ", val);
> +			deb_info(KERN_CONT, " %02x", val);

No comma after KERN_CONT

>  		else
> -			strcpy(buf2, "-- ");
> -		strcat(buf, buf2);
> +			deb_info(KERN_CONT, " --");

No comma after KERN_CONT

Just use printk() instead of deb_info() for the ones that use KERN_CONT.

>  		if (reg == 0xff)
>  			break;
>  	}
> -	deb_info("%s\n", buf);
> +	deb_info(KERN_CONT "\n");
>  	return 0;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
