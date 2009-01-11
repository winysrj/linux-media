Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZAKXQ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 18:16:29 -0500
Date: Sun, 11 Jan 2009 21:15:56 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: hvaibhav@ti.com, video4linux-list@redhat.com,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 2/2] Added OMAP3EVM Multi-Media Daughter Card
 Support
Message-ID: <20090111211556.25d9d3c4@pedra.chehab.org>
In-Reply-To: <1231551681.4474.238.camel@tux.localhost>
References: <hvaibhav@ti.com>
	<1231308470-31159-1-git-send-email-hvaibhav@ti.com>
	<1231551681.4474.238.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 10 Jan 2009 04:41:21 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> On Wed, 2009-01-07 at 11:37 +0530, hvaibhav@ti.com wrote:
>  [...]  
> 
> You have a lot of dprintk messages. May be it's better to move "\n" to
> dprintk definition? And use dprintk without \n.
> Probably, makes your life easier :)

Please, don't. On almost all places where *print* is used, \n is required.
Moving the end of line character into dprintk will just be something non-standard.

> > +		return -EPERM;
> > +	}
> > +
> > +
> > +	switch (mux_id) {
> > +	case MUX_TVP5146:
> > +		/* active low signal. set 0 to enable, 1 to disable */
> > +		if (ENABLE_MUX == value) {
> > +			/* pull down the GPIO GPIO134 = 0 */
> > +			gpio_set_value(GPIO134_SEL_Y, 0);
> > +			/* pull up the GPIO GPIO54 = 1 */
> > +			gpio_set_value(GPIO54_SEL_EXP_CAM, 1);
> > +			/* pull up the GPIO GPIO136 = 1 */
> > +			gpio_set_value(GPIO136_SEL_CAM, 1);
> > +		} else
> > +			/* pull up the GPIO GPIO134 = 0 */
> > +			gpio_set_value(GPIO134_SEL_Y, 1);  
> 
> Well, please chech the Documentation/CodingStyle file.
> Comments there say that you should use bracers with else expression
> (statement?) also. Care to reformat the patch that it will look like:

Agreed, but, in this specific case, just remove above the comments, or replace
to something more useful. 
Currently, they are just repeating what the code is saying. The comments should
document why you need to change the gpio. Something like:

		/* Enable device foo */
		gpio_set_value(GPIO136_bar, 1);

Cheers,
Mauro
