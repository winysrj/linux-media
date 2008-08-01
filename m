Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 1 Aug 2008 11:21:38 +1000
From: Anton Blanchard <anton@samba.org>
To: Steven Toth <stoth@linuxtv.org>
Message-ID: <20080801012138.GA7094@kryten>
References: <20080630235654.CCD891CE833@ws1-6.us4.outblaze.com>
	<20080731042433.GA21788@kryten> <4891D557.10901@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4891D557.10901@linuxtv.org>
Cc: linux-dvb@linuxtv.org, "stev391@email.com" <stev391@email.com>,
	linuxdvb@itee.uq.edu.au
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO
	FusionHDTV	DVB-T Dual Express
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

> Please try to confirm to the callback cx23885_tuner_callback, we don't  
> want/need a dvico specific callback.:
>
> http://linuxtv.org/hg/~stoth/v4l-dvb/rev/2d925110d38a

Good idea, a series will follow that does this. I think the tuner
callbacks could do with some cleaning up (as you will see in the patch
series), but I think what I have now is a step in the right direction.

Anton

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
