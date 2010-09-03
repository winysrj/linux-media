Return-path: <mchehab@pedra>
Received: from smtp5-g21.free.fr ([212.27.42.5]:45021 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0ICIil convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 04:38:41 -0400
Date: Fri, 3 Sep 2010 10:38:38 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdgoede@redhat.com>
Subject: Re: [PATCH] gspca_cpia1: Add lamp control for Intel Play QX3
 microscope
Message-ID: <20100903103838.23d759c9@tele>
In-Reply-To: <1283476182.17527.4.camel@morgan.silverblock.net>
References: <1283476182.17527.4.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 02 Sep 2010 21:09:42 -0400
Andy Walls <awalls@md.metrocast.net> wrote:
	[snip]
> Add a v4l2 control to get the lamp control code working for the Intel
> Play QX3 microscope.  My daughter in middle school thought it was
> cool, and is now examining the grossest specimens she can find.
	[snip]
> -		u8 toplight;            /* top light lit , R/W */
> -		u8 bottomlight;         /* bottom light lit, R/W */
> +		u8 toplamp;             /* top lamp lit , R/W */
> +		u8 bottomlamp;          /* bottom lamp lit, R/W */
	[snip]
> +#define V4L2_CID_LAMPS (V4L2_CID_PRIVATE_BASE+1)
	[snip]

Hi Andy,

First, I do not see why you changed the name 'light' to 'lamp' while
'light' is used in the other cpia driver (cpia2).

Then, you used a private control ID, and linux-media people don't like
that.

As many gspca users are waiting for a light/LED/illuminator/lamp
control, I tried to define a standard one in March 2009:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/3095

A second, but more restrictive, attempt was done by Németh Márton in
February 2010:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16705

The main objection to that proposals was that the sysfs LED interface
should be used instead:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/3114

A patch in this way was done by Németh Márton in February 2010:
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16670

but it was rather complex, and there was no consensus
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17111

So, I don't think that your patch could be accepted...

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
