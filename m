Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JkJTB-0005DO-Ex
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 15:39:10 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18be07c9.dyn.optonline.net [24.190.7.201]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZ5006SUXW7J5U0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 11 Apr 2008 09:38:31 -0400 (EDT)
Date: Fri, 11 Apr 2008 09:38:31 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <ea4209750804110226u18388307m48c629fe69b20d99@mail.gmail.com>
To: Albert Comerma <albert.comerma@gmail.com>,
	Jernej Tonejc <tonejc@math.wisc.edu>
Message-id: <47FF69D7.5070209@linuxtv.org>
MIME-version: 1.0
References: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
	<ea4209750804110226u18388307m48c629fe69b20d99@mail.gmail.com>
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

Albert Comerma wrote:
> For the chips you list it seems to be an hybrid card, with a dibcom 
> bridge. In this case, what's more easy is to make dvb-t working (dib0700 
> + xc5000)  as you have tried. But there's no frontend which uses xc5000, 
> so a new one must be specified. In theory xc5000 is supported.... I hope 
> this helps.


Lots of frontends use the xc5005. stoth/hvr950q uses the au8522 and the 
xc5000. The cx23885 tree has concrete examples of the s5h1409 using the 
xc5000 (hvr1500q).


> 
> Albert
> 
> 2008/4/11 Jernej Tonejc <tonejc@math.wisc.edu 
> <mailto:tonejc@math.wisc.edu>>:
> 
>     Hi,
> 
>     I was wondering if anyone is working on enabling this device under
>     linux.
>     I took it apart and it contains the following chips:
> 
>     DIBcom 0700C-XCCXa-G
>     USB 2.0 D3LTK.1
>     0804-0100-C
>     -----------------

Hmm. I haven't really used the dibcom src but I think this is already 
supported.

>     SAMSUNG
>     S5H1411X01-Y0
>     NOTKRSUI H0801

I have a driver for this, I hope to release it shortly.

>     -----------------
>     XCeive
>     XC5000AQ
>     BK66326.1
>     0802MYE3
>     -----------------

I did a driver for this, it's already in the kernel.

>     Cirrus
>     5340CZZ
>     0748
>     -----------------

Already exists.

>     CONEXANT
>     CX25843-24Z
>     71035657
>     0742 KOREA
>     -----------------

Already exists

> 
>     It seems that all parts should be more or less supported. I played
>     around

No, see my comment above.

Why not get involved and scratch your own itch? :)

The community could use more developers, why not roll up your sleeves 
and help solve your problem - and the problem for others? Everyone has 
to start somewhere and usually when would-be developers ask questions - 
everyone is willing to help.

Regards,

Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
