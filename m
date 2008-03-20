Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailout05.sul.t-online.de ([194.25.134.82])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hartmut.hackmann@t-online.de>) id 1JcRnp-0001Z9-V2
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 21:55:58 +0100
Message-ID: <47E2CF49.8070302@t-online.de>
Date: Thu, 20 Mar 2008 21:55:37 +0100
From: Hartmut Hackmann <hartmut.hackmann@t-online.de>
MIME-Version: 1.0
To: ldvb@ns.bog.msu.ru
References: <Pine.LNX.4.62.0803141625320.8859@ns.bog.msu.ru>	<Pine.LNX.4.62.0803141819410.8859@ns.bog.msu.ru>	<Pine.LNX.4.62.0803171305520.18849@ns.bog.msu.ru>	<200803200118.26462@orion.escape-edv.de>
	<Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
In-Reply-To: <Pine.LNX.4.62.0803201931260.12540@ns.bog.msu.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TDA10086 fails? DiSEqC bad? TT S-1401 Horizontal
 transponder fails
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

ldvb@ns.bog.msu.ru schrieb:
> On Thu, 20 Mar 2008, Oliver Endriss wrote:
> 
>> Sorry, if you want to have your problem fixed, you have dig through the
>> register programming of the frontend driver. Use an i2c sniffer and
>> compare the register settings of the the windows driver with those of
>> the linux driver...
>> If you want to experiment with some parameters, you might have a look at
>> changeset
>>  http://linuxtv.org/hg/v4l-dvb/rev/8a19aa788239
>> Maybe you can find a better register setting which fixes your problem.
> 
> Increased baseband cut-off helps! (tda826*.c)
> so, making it
> buf[6] = 0xfe;
> solves the problem.
> Maybe, I'll check other values.
> 
This might be right! I could not get good information regarding the
transponder bandwidths. We might need to make this depend on the
symbol rate or a module parameter.
Can we grind this out after easter?

Best regards
  Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
