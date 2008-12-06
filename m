Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L8v0H-0003Nw-Fh
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 12:07:18 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mB6B7DFx013537
	for <linux-dvb@linuxtv.org>; Sat, 6 Dec 2008 12:07:13 +0100
Message-ID: <493A5CE1.7000009@cadsoft.de>
Date: Sat, 06 Dec 2008 12:07:13 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <alpine.LRH.1.10.0810191843050.31488@pub2.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0810191843050.31488@pub2.ifh.de>
Subject: Re: [linux-dvb] DVBv5 (S2API) API for DVB-T
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 19.10.2008 20:31, Patrick Boettcher wrote:
> Hi Steve and others,
> 
> I was quite busy recently and only found now the time to do what I
> should have done some time ago as it turned out. I could beat myself.
> 
> When I checked how DVB-T is now implemented I saw that there is one
> thing which was wrong in the DVBv3 API already and is still in DVBv5.
> 
> It is regarding hierarchical transmissions and the selection of
> high-priority and low-priority streams. This was not possible with DVBv3.
> 
> I quickly changed how I think it should be done and the resulting patch
> can be found attached.
> 
> The worst is, that this patch changes the frontend.h and thus the user
> interface. I put some comments in the code I wrote which hopefully helps
> to understand why I think this is necessary.
> 
> I hope it is not too late to apply this and to go for 2.6.28 . If it is,
> my bad and everyone can blame me for not having a proper hierarchical
> mode implemented.
> 
> Sorry again,
> Patrick.

[ see http://linuxtv.org/pipermail/linux-dvb/2008-October/029852.html for the patch ]

I'm at the "final approach" of releasing an S2API adapted version of
VDR 1.7.2, so I'm wondering if this change is going to be adopted in the
driver or not, or whether it is at all feasible. There haven't been any
comments in almost two months...

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
