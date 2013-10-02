Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:26887 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3JBRdt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Oct 2013 13:33:49 -0400
Date: Wed, 02 Oct 2013 14:33:40 -0300
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
Message-id: <20131002143340.18639f1a@samsung.com>
In-reply-to: <524C482E.3050003@st.com>
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com>
 <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
 <52458774.1060909@st.com> <20130927105716.64349f02@samsung.com>
 <524935D6.1010505@st.com> <20131001114949.5a26dd70.m.chehab@samsung.com>
 <524C482E.3050003@st.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 02 Oct 2013 17:22:06 +0100
Srinivas KANDAGATLA <srinivas.kandagatla@st.com> escreveu:

> On 01/10/13 15:49, Mauro Carvalho Chehab wrote:
> >>> > > 
> >>> > > Btw, we're even thinking on mapping HDMI-CEC remote controller RX/TX via
> >>> > > the RC subsystem. So, another L1 protocol would be "hdmi-cec".
> >>> > > 
> >> > Ok.
> >>> > > Yet, it seems unlikely that the very same remote controller IP would use
> >>> > > a different protocol for RX and TX, while sharing the same registers.
> >> > 
> >> > ST IRB block has one IR processor which has both TX and RX support and
> >> > one UHF Processor which has RX support only. However the register map
> >> > for all these support is in single IRB IP block.
> >> > 
> >> > So the driver can configure the IP as TX in "infrared" and RX in "uhf".
> >> > This is supported in ST IRB IP.
> >> > 
> >> > This case can not be represented in a single device tree node with
> >> > l1-protocol and direction properties.
> >> > 
> >> > IMHO, having tx-mode and rx-mode or tx-protocol and rx-protocol
> >> > properties will give more flexibility.
> >> > 
> >> > What do you think?
> > Yeah, if they're using the same registers, then your proposal works
> > better.
> > 
> > I would prefer to not call it as just protocol, as IR has an
> > upper layer protocol that defines how the bits are encoded, e. g.
> > RC5, RC6, NEC, SONY, ..., with is what we generally call as protocol
> > on rc-core. 
> > 
> > A proper naming for it is hard to find. Well, for IR/UHF, it is actually
> 
> Yes I agree.
> 
> > specifying the medium, but for Bluetooth, HDMI-CEC, it defines a
> > protocol stack to be used, with covers not only the physical layer of
> > the OSI model.
> > 
> > Perhaps the better would be to call it as: tx-proto-stack/rx-proto-stack.
> > 
> How are we going to address use case highlighted by Mark R, like N
> Connections on a single IP block?
> 
> This use-case can not be addressed with tx-mode and rx-mode or
> tx-proto-stack/rx-proto-stack properties.
> 
> So the idea of generic properties for tx and rx sounds incorrect.
> 
> IMHO, Best thing would be to drop the idea of using tx-mode and rx-mode
> as generic properties and use "st,tx-mode" and "st,rx-mode" instead for
> st-rc driver.
> 
> What do you think?

Well, from userspace PoV, it should have just one devnode for each
TX/RX.

So, if the device has N TX and/or RX simultaneous connections, it should
be exposing N device nodes, and the DT should for it should have N entries,
one for each.

A completely independent issue is how the driver will prevent to have
two simultaneous access to the same resource.

As on any other type of resource, there are several alternatives:

	- block the reads/writes, if some I/O operation is pending;
	- return -EAGAIN where the API allows (non-block calls),
	  and the error is temporary;
	- return -EBUSY if the resource is more "permanently" allocated.

So, if the very same registers are used by more than one TX/RX unit,
then the driver should for example have a mutex/semaphore to lock such
I/O while another I/O operation is undergoing.

That solution is the same used by I2C devices: the I2C bus has a lock,
serializing the access to all devices on that bus.

There is another possible scenario: a device that have more than one
connection, and that userspace could setup what connection is active,
putting all the other ones inactive.

On such scenario, we would need to add more bits at RC API, in order
to allow userspace to enumerate the possible RX/TX connections,
and to change it at runtime.

If we had such scenario, then the DT representation for it could be
different. So, instead of having a single TX/RX mode/protocol-stack,
we would have a connections table. Also, each entry would likely need
a name, in order to allow userspace to distinguish between the diferent
entries that are wired on a given board.

Anyway, we don't have such scenario yet. So, let's not overdesign the
API, thinking on a possible scenario that may never happen.

> 
> Thanks,
> srini
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
