Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:51048 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3HPLki (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 07:40:38 -0400
Date: Fri, 16 Aug 2013 12:40:35 +0100
From: Sean Young <sean@mess.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Rob Landley <rob@landley.net>,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] media: st-rc: Add ST remote control driver
Message-ID: <20130816114035.GA1978@pequod.mess.org>
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com>
 <20130816083853.GA6844@pequod.mess.org>
 <520E04BC.10908@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E04BC.10908@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 16, 2013 at 11:53:48AM +0100, Srinivas KANDAGATLA wrote:
> Thanks Sean for the comments.
> On 16/08/13 09:38, Sean Young wrote:
> > On Wed, Aug 14, 2013 at 06:27:01PM +0100, Srinivas KANDAGATLA wrote:
> [...]
> >> +			/* discard the entire collection in case of errors!  */
> >> +			dev_info(dev->dev, "IR RX overrun\n");
> >> +			writel(IRB_RX_OVERRUN_INT,
> >> +					dev->rx_base + IRB_RX_INT_CLEAR);
> >> +			continue;
> >> +		}
> >> +
> >> +		symbol = readl(dev->rx_base + IRB_RX_SYS);
> >> +		mark = readl(dev->rx_base + IRB_RX_ON);
> >> +
> >> +		if (symbol == IRB_TIMEOUT)
> >> +			last_symbol = 1;
> >> +
> >> +		 /* Ignore any noise */
> >> +		if ((mark > 2) && (symbol > 1)) {
> >> +			symbol -= mark;
> >> +			if (dev->overclocking) { /* adjustments to timings */
> >> +				symbol *= dev->sample_mult;
> >> +				symbol /= dev->sample_div;
> >> +				mark *= dev->sample_mult;
> >> +				mark /= dev->sample_div;
> >> +			}
> >> +
> >> +			ev.duration = US_TO_NS(mark);
> >> +			ev.pulse = true;
> >> +			ir_raw_event_store(dev->rdev, &ev);
> >> +
> >> +			if (!last_symbol) {
> >> +				ev.duration = US_TO_NS(symbol);
> >> +				ev.pulse = false;
> >> +				ir_raw_event_store(dev->rdev, &ev);
> > 
> > Make sure you call ir_raw_event_handle() once a while (maybe every time
> > the interrupt handler is called?) to prevent the ir kfifo from 
> > overflowing in case of very long IR. ir_raw_event_store() just adds
> > new edges to the kfifo() but does not flush them to the decoders or
> > lirc.
> I agree, but Am not sure it will really help in this case because, we
> are going to stay in this interrupt handler till we get a
> last_symbol(full key press/release event).. So calling
> ir_raw_event_store mulitple times might not help because the
> ir_raw_event kthread(which is clearing kfifo) which is only scheduled
> after returning from this interrupt.

If I read it correctly, then this is only true if the fifo contains an 
IRB_TIMEOUT symbol. If not yet, then the interrupt handlers is not 
waiting around for those symbols to arrive.

Thanks
Sean
