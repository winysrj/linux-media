Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1L9dD2-00071H-7W
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 11:19:26 +0100
Date: Mon, 8 Dec 2008 11:18:40 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
In-Reply-To: <493A5CE1.7000009@cadsoft.de>
Message-ID: <alpine.LRH.1.10.0812081111150.29262@pub2.ifh.de>
References: <alpine.LRH.1.10.0810191843050.31488@pub2.ifh.de>
	<493A5CE1.7000009@cadsoft.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

Hi,

On Sat, 6 Dec 2008, Klaus Schmidinger wrote:
>> I hope it is not too late to apply this and to go for 2.6.28 . If it is,
>> my bad and everyone can blame me for not having a proper hierarchical
>> mode implemented.
>
> [ see http://linuxtv.org/pipermail/linux-dvb/2008-October/029852.html for the patch ]
>
> I'm at the "final approach" of releasing an S2API adapted version of
> VDR 1.7.2, so I'm wondering if this change is going to be adopted in the
> driver or not, or whether it is at all feasible. There haven't been any
> comments in almost two months...

It was not merged and there was no reaction.

As it is now too late (it is, right?), the only solution to fix a possible 
hierarchical transmission will be to add the "select_stream" command. Like 
that it will be possible to select high or low priority. It is not as 
clean as by patch, but it will work and is backward compatible. For that I 
don't have a patch ready, but at the same time there is also no 
hierarchical transmission (afaik) in the air nowhere on the world. Only in 
labs.

best regards,
Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
