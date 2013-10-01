Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:38475 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab3JAOuB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Oct 2013 10:50:01 -0400
Date: Tue, 01 Oct 2013 11:49:49 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: srinivas.kandagatla@st.com
Cc: Mark Rutland <mark.rutland@arm.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for remote-control
Message-id: <20131001114949.5a26dd70.m.chehab@samsung.com>
In-reply-to: <524935D6.1010505@st.com>
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com>
 <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
 <52458774.1060909@st.com> <20130927105716.64349f02@samsung.com>
 <524935D6.1010505@st.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Sep 2013 09:27:02 +0100
Srinivas KANDAGATLA <srinivas.kandagatla@st.com> escreveu:

> On 27/09/13 14:57, Mauro Carvalho Chehab wrote:
> > Em Fri, 27 Sep 2013 14:26:12 +0100
> > Srinivas KANDAGATLA <srinivas.kandagatla@st.com> escreveu:
> > 
> >> On 27/09/13 12:34, Mark Rutland wrote:
> >>
> >>>>> +	- rx-mode: Can be "infrared" or "uhf". rx-mode should be present iff
> >>>>> +	  the rx pins are wired up.
> >>> I'm unsure on this. What if the device has multiple receivers that can
> >>> be independently configured? What if it supports something other than
> >>> "infrared" or "uhf"? What if a device can only be wired up as
> >>> "infrared"? 
> >>>
> >>> I'm not sure how generic these are, though we should certainly encourage
> >>> bindings that can be described this way to be described in the same way.
> >>>
> >>>>> +	- tx-mode: Can be "infrared" or "uhf". tx-mode should be present iff
> >>>>> +	  the tx pins are wired up.
> >>> I have similar concerns here to those for the rx-mode property.
> >>>
> >> Initially rx-mode and tx-mode sounded like more generic properties
> >> that's the reason I ended up in this route. But after this discussion it
> >> looks like its not really generic enough to cater all the use cases.
> >>
> >> It make sense for me to perfix "st," for these properties in the st-rc
> >> driver rather than considering them as generic properties.
> > 
> > Well, for sure the direction (TX, RX, both) is a generic property.
> > 
> > I'd say that the level 1 protocol (IR, UHF, Bluetooth, ...) is also a
> > generic property. Most remotes are IR, but there are some that are
> > bluetooth, and your hardware is using UHF.
> Yes these are generic.
> 
> > 
> > Btw, we're even thinking on mapping HDMI-CEC remote controller RX/TX via
> > the RC subsystem. So, another L1 protocol would be "hdmi-cec".
> > 
> Ok.
> > Yet, it seems unlikely that the very same remote controller IP would use
> > a different protocol for RX and TX, while sharing the same registers.
> 
> ST IRB block has one IR processor which has both TX and RX support and
> one UHF Processor which has RX support only. However the register map
> for all these support is in single IRB IP block.
> 
> So the driver can configure the IP as TX in "infrared" and RX in "uhf".
> This is supported in ST IRB IP.
> 
> This case can not be represented in a single device tree node with
> l1-protocol and direction properties.
> 
> IMHO, having tx-mode and rx-mode or tx-protocol and rx-protocol
> properties will give more flexibility.
> 
> What do you think?

Yeah, if they're using the same registers, then your proposal works
better.

I would prefer to not call it as just protocol, as IR has an
upper layer protocol that defines how the bits are encoded, e. g.
RC5, RC6, NEC, SONY, ..., with is what we generally call as protocol
on rc-core. 

A proper naming for it is hard to find. Well, for IR/UHF, it is actually
specifying the medium, but for Bluetooth, HDMI-CEC, it defines a
protocol stack to be used, with covers not only the physical layer of
the OSI model.

Perhaps the better would be to call it as: tx-proto-stack/rx-proto-stack.

> 
> > 
> > So, for example, a hardware with "hdmi-cec" and "infrared" will actually
> > have two remote controller devices. Eventually, the "infrared" being
> > just RX, while "hdmi-cec" being bi-directional.
> > 
> > So, IMHO, this could be mapped as "l1_protocol" ("infrared", "uhf", ...)
> > and another one "direction" ("rx", "tx", "bi-directional").
> > 
> 
> Thanks,
> srini

Regards,
Mauro
