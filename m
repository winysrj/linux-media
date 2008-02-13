Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from gw.deuromedia.ro ([194.176.161.33] helo=deuromedia.de)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Doru.Marin@Deuromedia.ro>) id 1JPIBG-0007pa-OS
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 15:01:46 +0100
Message-ID: <47B2F82F.6070804@Deuromedia.ro>
Date: Wed, 13 Feb 2008 16:01:19 +0200
From: Doru Marin <Doru.Marin@Deuromedia.ro>
MIME-Version: 1.0
To: w3ird_n3rd@gmx.net
References: <47B19015.20208@gmx.net>
In-Reply-To: <47B19015.20208@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DiSEqC trouble with TT S-1500
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Can you explain how you select those 4 positions ? DiSEqC commands or 
tone/voltage changes ?
Also can you determine the input type of those positions (Hi/Low, H/V, 
etc) ? A scenario to see when and why that happens, would be more useful.

P. van Gaans wrote:
> Hi,
>
> I've got a Technotrend S-1500 (if it matters: I use it with Kaffeine 
> 0.8.3). It works mostly fine, but there's a strange problem. With my 
> Spaun 4/1 DiSEqC switch (they cost approx 25-40 euro), I can only switch 
> without trouble to position 1 and 2. If I tune directly to position 3 it 
> won't lock.
>
> However, if I first tune to a channel on position 1 or 2 and try a 
> channel on position 3 after that, it will work. Position 4 however is 
> completely unreachable.
>
> On a standalone receiver, there's no trouble with the same cable.
>
> Now Spaun is a really expensive and respected brand. So their switches 
> possibly work in a different way, because a cheap Maximum 4/1 switch 
> works perfectly with the S-1500. Position 1, 2, 3 and 4 all work 
> perfectly. I also did some "dry testing" indoors and it looks like a 7 
> euro Satconn 4/1 switch would also work fine, but a 17 euro Axing SPU 
> 41-02 probably won't.
>
> I'm guessing this could be solved in stv0299.c but I'm not much of an 
> expert. I took a look at the code but I'm not really sure what to do.
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
