Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57955 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbaCQL7I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 07:59:08 -0400
Received: from minime.bse ([77.20.176.42]) by mail.gmx.com (mrgmx001) with
 ESMTPSA (Nemesis) id 0Lbdl5-1Wrfsn1CdH-00lH0L for
 <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 12:59:06 +0100
Date: Mon, 17 Mar 2014 12:59:04 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] bttv: Add support for PCI-8604PW
Message-ID: <20140317115904.GA10962@minime.bse>
References: <1394966028-1277-1-git-send-email-daniel-gl@gmx.net>
 <5326C3FD.4030302@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5326C3FD.4030302@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Mar 17, 2014 at 10:44:29AM +0100, Hans Verkuil wrote:
> > +		switch (state) {
> > +		case 1:
> > +		case 5:
> > +		case 6:
> > +		case 4:
> > +			pr_debug("PCI-8604PW in state %i, toggling pin\n",
> > +				 state);
> > +			btwrite(0x080000, BT848_GPIO_DATA);
> > +			msleep(1);
> > +			btwrite(0x000000, BT848_GPIO_DATA);
> > +			msleep(1);
> > +			break;
> > +		case 7:
> > +			pr_info("PCI-8604PW unlocked\n");
> > +			return;
> > +		case 0: /* FIXME */
> 
> Fix what? My guess is that if this state happens, then you have no idea how to
> get out of it. Did you actually see this happen, or is this a theoretical case?

yes, if we are in state 7 and toggle GPIO[19] one more time, the CPLD
goes into state 0, where PCI bus mastering is inhibited again.
We have not managed to get out of that state.

> > +			pr_err("PCI-8604PW locked until reset\n");
> > +			return;

> > +		state = (state << 4) | ((btread(BT848_GPIO_DATA) >> 21) & 7);
> > +
> > +		switch (state) {
> > +		case 0x15:
> > +		case 0x56:
> > +		case 0x64:
> > +		case 0x47:
> > +/*		case 0x70: */
> 
> Why is this commented out?

The transition from state 7 to state 0 is, as explained above, valid
but undesired and with this code impossible as we exit as soon as we
are in state 7.

Best regards,

  Daniel
