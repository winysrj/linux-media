Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 12 Sep 2008 12:17:44 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080912152755.GA29142@linuxtv.org>
To: Johannes Stezenbach <js@linuxtv.org>
Message-id: <48CA9628.7030709@linuxtv.org>
MIME-version: 1.0
References: <48CA0355.6080903@linuxtv.org> <200809120826.31108.hftom@free.fr>
	<48CA6C2E.7050908@linuxtv.org> <200809121529.41795.hftom@free.fr>
	<48CA77DE.1020700@linuxtv.org> <20080912152755.GA29142@linuxtv.org>
Cc: Steven Toth <stoth@hauppauge.com>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - Status  - Thu Sep 11th
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

Johannes Stezenbach wrote:
> On Fri, Sep 12, 2008, Steven Toth wrote:
>> Christophe Thommeret wrote:
>>> As far  as i understand, the cinergyT2 driver is a bit unusual, e.g. 
>>> dvb_register_frontend is never called (hence no dtv_* log messages). I don't 
>>> know if there is others drivers like this, but this has to be investigated 
>>> cause rewritting all drivers for S2API could be a bit of work :)
>>>
>>> P.S.
>>> I think there is an alternate driver for cinergyT2 actually in developement 
>>> but idon't remember where it's located neither its state.
>> Good to know. (I also saw your followup email). I have zero experience 
>> with the cinergyT2 but the old api should still be working reliably. I 
>> plan to investigate this, sounds like a bug! :)
> 
> Holger was of the opinion that having the demux in dvb-core
> was stupid for devices which have no hw demux, so he
> programmed around dvb-core. His plan was to add a
> mmap-dma-buffers kind of API to the frontend device,
> but it never got implemented.
> 
> Anyway, it's bad if one driver is different than all the others.

Hmm, I didn't realize this, good to know.

Now it's peaked my interest, I'll have to look at the code.

The existing API should still work at a bare minimum, if it's not - it 
needs to.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
