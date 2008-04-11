Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
MIME-version: 1.0
Date: Fri, 11 Apr 2008 12:18:45 -0500 (CDT)
From: Jernej Tonejc <tonejc@math.wisc.edu>
In-reply-to: <47FF8E6C.8030300@linuxtv.org>
To: Steven Toth <stoth@linuxtv.org>
Message-id: <Pine.LNX.4.64.0804111213520.3892@garbadale.math.wisc.edu>
References: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
	<ea4209750804110226u18388307m48c629fe69b20d99@mail.gmail.com>
	<47FF69D7.5070209@linuxtv.org>
	<Pine.LNX.4.64.0804110900070.3892@garbadale.math.wisc.edu>
	<47FF8E6C.8030300@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV HD pro USB stick 801e
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

On Fri, 11 Apr 2008, Steven Toth wrote:

>
> The s5h1409 is a different beast to the s5h1411, so you're wasting your time 
> trying to make that work.

Hi Steve,

is there any way you could send me at least the preliminary version of the 
s5h1411 driver or tell me where I could get one? This would make it easier 
to test whether the frontend attaching code works or not - right now I 
have no way of knowing since it doesn't recognize the part. I will focus 
on getting the xc5000 tuner to work later. With the frontend it should be 
possible to watch/test digital stuff, right?

> That being said, I'm kinda surprised you're having i2c scan issues. I don't 
> work with the dibcom src so maybe that's a true limitation of the part, or 
> maybe something else is just plain broken on your design.

> Googling/searching the mailing list, or reading the wiki's at linuxtv.org 
> might show a reason why I2C scanning isn't supported.

I'll do that.

Regards,
  Jernej

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
