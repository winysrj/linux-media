Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Wed, 10 Sep 2008 11:27:31 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Steven Toth <stoth@linuxtv.org>
In-Reply-To: <48C72F99.20501@linuxtv.org>
Message-ID: <alpine.LRH.1.10.0809101111130.30794@pub2.ifh.de>
References: <48C72F99.20501@linuxtv.org>
MIME-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] S2API - Code review and suggested changes (1)
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

Hi Steve,

On Tue, 9 Sep 2008, Steven Toth wrote:
> * I think it would be better to change TV_ to FE_ (because TV is by
> * far not
> * the only application for linux-dvb) , but this is a very unimportant
> * detail.
>
> A few people prefer dtv_ and DTV_, rather than tv_ and TV_. is fe_
> and FE_ still important to you?

Expanding the term "dtv" to digital television and then translate 
television into "seeing something somewhere which takes/took place 
somewhere else" I can agree with the dtv-prefix.

Still I think the term TV is used by a lot of people with different 
understandings. But except me nobody has seen the term dtv too 
restrictive, so I'm joining the majority.

On thing I almost forgot: You should add a bandwidth-thing as an integer, 
like the frequency/symbolrate.

For DVB-T we (DiBcom) can basicly run with any channel bandwidth, not only 
5,6,7,8 MHz. And some people are even using it...

Another example: DVB-SH is mentioning explicitly a 1.7 MHz bandwidth in 
the spec (default is 5MHz).

Please consider adapting it.

thanks,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
