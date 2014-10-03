Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0141.hostedemail.com ([216.40.44.141]:37177 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751965AbaJCBlb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 21:41:31 -0400
Message-ID: <1412300487.3247.91.camel@joe-AO725>
Subject: Re: [PATCH] Fixed all coding style issues for
 drivers/staging/media/lirc/
From: Joe Perches <joe@perches.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Amber Thrall <amber.rose.thrall@gmail.com>, jarod@wilsonet.com,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 18:41:27 -0700
In-Reply-To: <542DE6B5.1060906@iki.fi>
References: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
	 <20141002102938.2b762583@recife.lan> <1412268351.3247.68.camel@joe-AO725>
	 <542DE6B5.1060906@iki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2014-10-03 at 02:58 +0300, Antti Palosaari wrote:
> On 10/02/2014 07:45 PM, Joe Perches wrote:
> > On Thu, 2014-10-02 at 10:29 -0300, Mauro Carvalho Chehab wrote:
> >> Em Wed, 01 Oct 2014 21:40:02 -0700 Amber Thrall <amber.rose.thrall@gmail.com> escreveu:
> >>> Fixed various coding style issues, including strings over 80 characters long and many
> >>> deprecated printk's have been replaced with proper methods.
> > []
> >>> diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
> > []
> >>> @@ -623,8 +623,8 @@ static void imon_incoming_packet(struct imon_context *context,
> >>>   	if (debug) {
> >>>   		dev_info(dev, "raw packet: ");
> >>>   		for (i = 0; i < len; ++i)
> >>> -			printk("%02x ", buf[i]);
> >>> -		printk("\n");
> >>> +			dev_info(dev, "%02x ", buf[i]);
> >>> +		dev_info(dev, "\n");
> >>>   	}
> >>
> >> This is wrong, as the second printk should be printk_cont.
> >>
> >> The best here would be to change all above to use %*ph.
> >> So, just:
> >>
> >> 	dev_debug(dev, "raw packet: %*ph\n", len, buf);
> >
> > Not quite.
> >
> > %*ph is length limited and only useful for lengths < 30 or so.
> > Even then, it's pretty ugly.
> >
> > print_hex_dump_debug() is generally better.
> 
> That is place where you print 8 debug bytes, which are received remote 
> controller code. IMHO %*ph format is just what you like in that case.

Hi Antti.

I stand by my statement as I only looked at the
patch snippet itself, not any function real code.

In the actual code, there's a test above it:

	if (len != 8) {
		dev_warn(dev, "imon %s: invalid incoming packet size (len = %d, intf%d)\n",
			__func__, len, intf);
		return;
	}

So in my opinion, this would be better/smaller as:

	dev_dbg(dev, "raw packet: %8ph\n", urb->transfer_buffer);

> Why print_hex_dump_debug() is better? IIRC it could not be even 
> controlled like those dynamic debug printings.

Nope, it is. (from printk.h)

#if defined(CONFIG_DYNAMIC_DEBUG)
#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
			     groupsize, buf, len, ascii)	\
	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
			 groupsize, buf, len, ascii)
#else
#define print_hex_dump_debug(prefix_str, prefix_type, rowsize,		\
			     groupsize, buf, len, ascii)		\
	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
		       groupsize, buf, len, ascii)
#endif /* defined(CONFIG_DYNAMIC_DEBUG) */

It prints multiple lines when the length is > 16.
It prints the ascii along with the hex if desired.

cheers, Joe

