Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outgoing.selfhost.de ([82.98.87.70] helo=mordac.selfhost.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bumkunjo@gmx.de>) id 1K0SKe-0007um-4C
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 04:21:05 +0200
From: bumkunjo@gmx.de
To: linux-dvb@linuxtv.org
Date: Mon, 26 May 2008 04:20:58 +0200
References: <20080525112820.374AC104F0@ws1-3.us4.outblaze.com>
In-Reply-To: <20080525112820.374AC104F0@ws1-3.us4.outblaze.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805260420.59067.bumkunjo@gmx.de>
Cc: stev391@email.com
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
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


Thanks for the patch, Frieder - it seems to work perfectly on my vdr box - all 
channels tune - good reception.
i will report if any issues appear. if I can help testing upcoming versions of 
the driver ask me.

Thanks a lot to Chris and Stephen for your work,

Jochen

Am Sonntag 25 Mai 2008 13:28:20 schrieb stev391@email.com:
>  Hans-Frieder,
>
> Thanks, for this patch.  I have tested it on 1 of 3 machines that I have
> access to with this DVB card. No issues (Now loads 80 firmwares, instead
> of 3)
>
> It doesn't break Chris Pascoe's xc-test branch with the DViCO Fusion HDTV
> DVB-T Dual Express.
>
> It also makes my patch, to get support into the v4l-dvb head, (newer
> version then posted here) work a lot more reliably (Perfectly on this
> test machine, I will run it on my mythbox for a week or so before I post
> it).
>
> I think you should email Chris Pascoe and petition him to include it in
> his branch.  As this will definitely help alot of people out.
>
> Thanks again,
>
> Stephen.
>
>   ----- Original Message -----
>   From: "Hans-Frieder Vogt"
>   To: "jochen s" , stev391@email.com
>   Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
>   Date: Fri, 23 May 2008 21:46:58 +0200
>
>
>   Jochen,
>
>   you are indeed missing firmwares. The xc-test branch from Chris
>   Pascoe uses the special collection of firmwares
>   xc3028-dvico-au-01.fw which only contains firmwares for 7MHz
>   bandwidth (just try to tune a channel in the 7MHz band to confirm
>   this). To make the card work also for other bandwidths please apply
>   the following patch and put the standard firmware for xc3028
>   (xc3028-v27.fw) in the usual place (e.g. /lib/firmware).
>
>   This approach should also work for australia, because the standard
>   firmware also contains those firmwares in xc3028-dvico-au-01.fw.
>
>   Stephen, can you confirm this?
>
>   Cheers,
>   Hans-Frieder
>
>   --- xc-test.orig/linux/drivers/media/video/cx23885/cx23885-dvb.c
>   2008-04-26 23:40:52.000000000 +0200
>   +++ xc-test/linux/drivers/media/video/cx23885/cx23885-dvb.c
>   2008-05-19 23:15:08.000000000 +0200
>   @@ -217,9 +217,9 @@ static int dvb_register(struct cx23885_t
>   .callback = cx23885_dvico_xc2028_callback,
>   };
>   static struct xc2028_ctrl ctl = {
>   - .fname = "xc3028-dvico-au-01.fw",
>   + .fname = "xc3028-v27.fw",
>   .max_len = 64,
>   - .scode_table = ZARLINK456,
>   + .demod = XC3028_FE_ZARLINK456,
>   };
>
>   fe = dvb_attach(xc2028_attach, port->dvb.frontend,



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
