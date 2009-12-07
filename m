Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935597AbZLGVXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 16:23:55 -0500
Message-ID: <4B1D726D.3010409@redhat.com>
Date: Mon, 07 Dec 2009 19:23:57 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@kernellabs.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
References: <20091022211330.6e84c6e7@hyperion.delvare>	 <4B02FDA4.5030508@infradead.org>	 <1a297b360911200129pe5af064wf9cf239851ac5c46@mail.gmail.com>	 <200911201237.31537.julian@jusst.de>	 <1a297b360911200808k12676112lf7a11f3dfd44a187@mail.gmail.com>	 <4B07290B.4060307@jusst.de>	 <a3ef07920912041202u78f4d12av8d7a49f5f91b3d56@mail.gmail.com> <37219a840912041259w499f2347he1b25c16550d671f@mail.gmail.com> <4B1D6CFA.2020602@infradead.org>
In-Reply-To: <4B1D6CFA.2020602@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:
> Michael Krufky wrote:
>> On Fri, Dec 4, 2009 at 3:02 PM, VDR User <user.vdr@gmail.com> wrote:
>>> No activity in this thread for 2 weeks now.  Has there been any progress?
> 
>> I have stated that I like Manu's proposal, but I would prefer that the
>> get_property (s2api) interface were used, because it totally provides
>> an interface that is sufficient for this feature.
> 
> I've ported Manu's proposal to S2API way of handling it. It is just compiled
> only. I haven't test it yet on a real driver.
> 
> Comments?
> 
> ---
> 
> Add support for frontend statistics via S2API
> 
> The current DVB V3 API to handle statistics has two issues:
> 	- Retrieving several values can't be done atomically;
> 	- There's no indication about scale information.
> 
> This patch solves those two issues by adding a group of S2API
> that handles the needed statistics operations. It basically ports the
> proposal of Manu Abraham <abraham.manu@gmail.com> To S2API.
> 
> As the original patch, both of the above issues were addressed.
> 
> In order to demonstrate the changes on an existing driver for the new API, I've
> implemented it at the cx24123 driver.
> 
> There are some advantages of using this approach over using the static structs
> of the original proposal:
> 	- userspace can select an arbitrary number of parameters on his get request;
> 	- the latency to retrieve just one parameter is lower than retrieving
> several parameters. On the cx24123 example, if user wants just signal strength,
> the latency is the same as reading one register via i2c bus. If using the original
> proposal, the latency would be 6 times worse, since you would need to get 3 properties
> at the same time;
> 	- the latency for reading all 3 parameters at the same time is equal to
> the latency of the original proposal;
> 	- if newer statistics parameters will be needed in the future, it is just
> a matter of adding additional S2API command/value pairs;
> 	- the DVB V3 calls can be easily implemented as a call to the new get_stats ops,
> without adding extra latency time.

In time:

I only wrote the get callback. It could be interesting to implement also the set callback
for the DTV_FE*_UNIT parameters if there are some cases where the same driver can provide
a different set of units/parameters. This way, it is possible for userspace to
negotiate what parameter type he wants, on such drivers.
> 
> Thanks to Manu Abraham <abraham.manu@gmail.com> for his initial proposal.
> 

Cheers,
Mauro.
