Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Mon, 11 Aug 2008 09:40:31 +1000
From: Anton Blanchard <anton@samba.org>
To: Michael Krufky <mkrufky@linuxtv.org>
Message-ID: <20080810234031.GB8402@kryten>
References: <20080804131051.GA7241@kryten>
	<37219a840808040935o3cf613bdvd644bb0e592c8430@mail.gmail.com>
	<20080809041847.GA5045@kryten> <489F2B71.4060607@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <489F2B71.4060607@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] DViCO FusionHDTV DVB-T Dual Digital 4 (rev
	2)
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


Hi Mike,

> I've applied your patch to my cxusb tree, with slight modifications. 
> Please test the tree and confirm proper operation before I request a
> merge into the master branch.
>
> http://linuxtv.org/hg/~mkrufky/cxusb

I just pulled and built this tree and it tested out OK.

> Perhaps we could put all of the dib7070p common setup into a dib7070p
> module, to centralize the duplicated code between dib0700 and cxusb. 
> This could also help to remove the static links described above.
> 
> I started playing around with this idea -- If I make any progress, I'll
> post the tree and ask for testers.

Sounds good. Thanks for all your help.

Anton

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
