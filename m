Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:44507 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab2KZPWk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 10:22:40 -0500
Date: Mon, 26 Nov 2012 16:23:18 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] gspca - ov534: Fix the light frequency filter
Message-ID: <20121126162318.228c249f@armhf>
In-Reply-To: <20121126140806.65a6aa2b310c774e4edd62c3@studenti.unina.it>
References: <20121122124652.3a832e33@armhf>
	<20121123180909.021c55a8c3795329836c42b7@studenti.unina.it>
	<20121123191232.7ed9c546@armhf>
	<20121126140806.65a6aa2b310c774e4edd62c3@studenti.unina.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Nov 2012 14:08:06 +0100
Antonio Ospite <ospite@studenti.unina.it> wrote:

> For now I'd NAK the patch since it is a regression for users
> with 50Hz power sources and it looks like it does not _always_ work for
> 60Hz either.
> 
> Should I remove it from patchwork as well?
> 
> As I have the webcam and can perform actual tests I'll coordinate with
> Fabian to have more details about why light frequency filter is not
> working for him with the current code, it works fine for me at 640x480,
> even if I can see that its effect is weaker at 320x240.

I wonder how it could work. Look at the actual code:

	val = val ? 0x9e : 0x00;
	if (sd->sensor == SENSOR_OV767x) {
		sccb_reg_write(gspca_dev, 0x2a, 0x00);
		if (val)
			val = 0x9d;	/* insert dummy to 25fps for 50Hz */
	}
	sccb_reg_write(gspca_dev, 0x2b, val);

According to the ov7720/ov7221 documentation, the register 2b is:

	2B EXHCL 00 RW Dummy Pixel Insert LSB
	               8 LSB for dummy pixel insert in horizontal direction

How could it act on the light frequency filter?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
