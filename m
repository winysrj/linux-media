Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:44467 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751648AbaJBQpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 12:45:55 -0400
Message-ID: <1412268351.3247.68.camel@joe-AO725>
Subject: Re: [PATCH] Fixed all coding style issues for
 drivers/staging/media/lirc/
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Amber Thrall <amber.rose.thrall@gmail.com>, jarod@wilsonet.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 09:45:51 -0700
In-Reply-To: <20141002102938.2b762583@recife.lan>
References: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
	 <20141002102938.2b762583@recife.lan>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2014-10-02 at 10:29 -0300, Mauro Carvalho Chehab wrote:
> Em Wed, 01 Oct 2014 21:40:02 -0700 Amber Thrall <amber.rose.thrall@gmail.com> escreveu:
> > Fixed various coding style issues, including strings over 80 characters long and many 
> > deprecated printk's have been replaced with proper methods.
[]
> > diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
[]
> > @@ -623,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
> >  	if (debug) {
> >  		dev_info(dev, "raw packet: ");
> >  		for (i = 0; i < len; ++i)
> > -			printk("%02x ", buf[i]);
> > -		printk("\n");
> > +			dev_info(dev, "%02x ", buf[i]);
> > +		dev_info(dev, "\n");
> >  	}
> 
> This is wrong, as the second printk should be printk_cont.
> 
> The best here would be to change all above to use %*ph.
> So, just:
> 
> 	dev_debug(dev, "raw packet: %*ph\n", len, buf);

Not quite.

%*ph is length limited and only useful for lengths < 30 or so.
Even then, it's pretty ugly.

print_hex_dump_debug() is generally better.


