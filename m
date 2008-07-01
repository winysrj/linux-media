Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail9.dslextreme.com ([66.51.199.94])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <daniel@gimpelevich.san-francisco.ca.us>)
	id 1KDn32-0008RB-CW
	for linux-dvb@linuxtv.org; Tue, 01 Jul 2008 23:06:01 +0200
Message-ID: <486A9A81.6080502@gimpelevich.san-francisco.ca.us>
Date: Tue, 01 Jul 2008 13:58:41 -0700
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48625984.9070708@linuxtv.org>
In-Reply-To: <48625984.9070708@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Initial support for AVerTVHD Volar
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

mkrufky@linuxtv.org wrote:
> Daniel Gimpelevich wrote:
>> Add initial support for these devices. The AGC and tracking filter 
>> settings are known to be wrong, but it generally works.
> Mauro,
> 
> Please be aware that Daniel and I have been working together on this -- 
> this patch just shows where he is at today -- it's not yet ready for merge.
> 
> Him and I are in chat on irc discussing ways to further clean this up.
> 
> When ready, I will push this up and ask you to pull.
> 
> Regards,
> 
> Mike

In tying up the AGC and tracking filter loose ends, I found that the 
Linux driver for the MaxLinear tuner always clears bit 5 (0x20) of the 
tuner's register 167 (0xa7), where the Windows driver always sets it. 
What does this bit do?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
