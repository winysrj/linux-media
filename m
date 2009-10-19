Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:54634 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbZJSJDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 05:03:01 -0400
Date: Mon, 19 Oct 2009 11:03:17 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Habib Seifzadeh <habibseifzadeh@yahoo.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Genius iLook 300
Message-ID: <20091019110317.4addddef@tele>
In-Reply-To: <247901.47271.qm@web35605.mail.mud.yahoo.com>
References: <247901.47271.qm@web35605.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 18 Oct 2009 23:41:36 -0700 (PDT)
Habib Seifzadeh <habibseifzadeh@yahoo.com> wrote:

> I bought a Genius iLook 300 webcam recently. After I discovered that
> my linux (Ubuntu 8.10) can't detect it automatically, I downloaded
> the latest gspca from
> http://linuxtv.org/hg/~jfrancois/gspca/archive/tip.tar.gz link. It
> was compiled without any problem but my computer can't still detect
> the webcam...
	[snip]

Hello Habib,

It seems that your webcam is 093a:2628 from Pixart and that it is close
to the webcam 093a:2620. As you have the last gspca, may you add the
line:

	{USB_DEVICE(0x093a, 0x2628), .driver_info = SENSOR_PAC7302},

after the line 1108 of pac7311.c (in linux/drivers/media/video/gspca/)
and check if it works? (don't forget to regenerate and reinstall the
drivers)

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
