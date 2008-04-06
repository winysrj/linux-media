Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47F8DC7E.6090309@linuxtv.org>
Date: Sun, 06 Apr 2008 10:21:50 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <52153.82.83.248.119.1207489187.squirrel@webmail.ip-minds.de>
	<47F8DB6D.6070804@linuxtv.org>
In-Reply-To: <47F8DB6D.6070804@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WinTV HVR 1400 (cx23885)
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

Steven Toth wrote:
> jean.bruenn@ip-minds.de wrote:
>> Hello,
>>
>> i bought a dvb-t card ago some days, now i'm tried to get it working in
>> linux without any luck. It seems that there are not many information
>> available for that card (google displays mostly other cards or product
>> information).
>>
>>     Hauppauge WinTV HVR 1400 Hybrid TV ExpressCard (Analog and Digital Tuner)
> 
> I think that has a tda10048, which I'm currently working on. If so I'll 
> add support for that card very quickly in the next couple of weeks.

No, This card uses an XC3028L with a DIB7000.

We're missing support for the low-powered xc part.  AFAIK, it should work with the current driver, but needs new firmware.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
