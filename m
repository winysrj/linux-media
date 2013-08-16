Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:47975 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756081Ab3HPMbj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Aug 2013 08:31:39 -0400
Message-ID: <520E183D.701@st.com>
Date: Fri, 16 Aug 2013 13:17:01 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
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
References: <1376501221-22416-1-git-send-email-srinivas.kandagatla@st.com> <20130816083853.GA6844@pequod.mess.org> <520E04BC.10908@st.com> <20130816114035.GA1978@pequod.mess.org>
In-Reply-To: <20130816114035.GA1978@pequod.mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/08/13 12:40, Sean Young wrote:
> On Fri, Aug 16, 2013 at 11:53:48AM +0100, Srinivas KANDAGATLA wrote:
>> Thanks Sean for the comments.
>> On 16/08/13 09:38, Sean Young wrote:
>>> On Wed, Aug 14, 2013 at 06:27:01PM +0100, Srinivas KANDAGATLA wrote:
>> [...]
>>>> +			/* discard the entire collection in case of errors!  */
>>>> +			dev_info(dev->dev, "IR RX overrun\n");
>>>> +			writel(IRB_RX_OVERRUN_INT,
>>>> +					dev->rx_base + IRB_RX_INT_CLEAR);
>>>> +			continue;
>>>> +		}
>>>> +
>>>> +		symbol = readl(dev->rx_base + IRB_RX_SYS);
>>>> +		mark = readl(dev->rx_base + IRB_RX_ON);
>>>> +
>>>> +		if (symbol == IRB_TIMEOUT)
>>>> +			last_symbol = 1;
>>>> +
>>>> +		 /* Ignore any noise */
>>>> +		if ((mark > 2) && (symbol > 1)) {
>>>> +			symbol -= mark;
>>>> +			if (dev->overclocking) { /* adjustments to timings */
>>>> +				symbol *= dev->sample_mult;
>>>> +				symbol /= dev->sample_div;
>>>> +				mark *= dev->sample_mult;
>>>> +				mark /= dev->sample_div;
>>>> +			}
>>>> +
>>>> +			ev.duration = US_TO_NS(mark);
>>>> +			ev.pulse = true;
>>>> +			ir_raw_event_store(dev->rdev, &ev);
>>>> +
>>>> +			if (!last_symbol) {
>>>> +				ev.duration = US_TO_NS(symbol);
>>>> +				ev.pulse = false;
>>>> +				ir_raw_event_store(dev->rdev, &ev);
>>>
>>> Make sure you call ir_raw_event_handle() once a while (maybe every time
>>> the interrupt handler is called?) to prevent the ir kfifo from 
>>> overflowing in case of very long IR. ir_raw_event_store() just adds
>>> new edges to the kfifo() but does not flush them to the decoders or
>>> lirc.
>> I agree, but Am not sure it will really help in this case because, we
>> are going to stay in this interrupt handler till we get a
>> last_symbol(full key press/release event).. So calling
>> ir_raw_event_store mulitple times might not help because the
>> ir_raw_event kthread(which is clearing kfifo) which is only scheduled
>> after returning from this interrupt.
> 
> If I read it correctly, then this is only true if the fifo contains an 
> IRB_TIMEOUT symbol. If not yet, then the interrupt handlers is not 
> waiting around for those symbols to arrive.

Yes, as we are clearing the fifo and fifo size is 64 words its always
highly possible that It will contain IRB_TIMEOUT for that interrupt.


Thanks,
srini
> 
> Thanks
> Sean
> 

