Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 13 Oct 2008 00:02:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Matthias Dahl <mldvb@mortal-soul.de>
Message-ID: <20081013000210.00a2981f@pedra.chehab.org>
In-Reply-To: <200810071636.32416.mldvb@mortal-soul.de>
References: <200810071636.32416.mldvb@mortal-soul.de>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] bug in locking patch for dvb ca en50221 driver
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

Hi Matthias,

On Tue, 7 Oct 2008 16:36:30 +0200
Matthias Dahl <mldvb@mortal-soul.de> wrote:

> Hello Mauro/Andreas.
> 
> Unfortunately the patch I sent a few weeks ago introduces a _very_ infrequent 
> timeout in dvb_ca_en50221_io_write which I have to investigate. I don't like 
> the idea of just increasing the timeout. But I am currently quite busy 
> because I have a deadline for a university project to meet. So please don't 
> sent the patch upstream until I have had a chance to look things over and 
> correct the situation. Thanks and sorry for the inconvenience but I haven't 
> run into this bug before and it's (at least on my machine) not so easy to 
> trigger.

Ok.

I removed this patch from my submit queue on my -git trees locally. Please,
let me know when you have a solution for this, in order to allow me to submit
both patches.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
