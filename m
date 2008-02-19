Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JRWIT-0007m4-TW
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 18:30:26 +0100
Received: by ti-out-0910.google.com with SMTP id y6so980594tia.13
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 09:30:20 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1203441662.9150.29.camel@acropora>
References: <1203434275.6870.25.camel@tux> <1203441662.9150.29.camel@acropora>
Date: Tue, 19 Feb 2008 18:30:13 +0100
Message-Id: <1203442213.7060.4.camel@tux>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat with
	dib0700	ir	receiver
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


Il giorno mar, 19/02/2008 alle 17.21 +0000, Nicolas Will ha scritto:
> On Tue, 2008-02-19 at 16:17 +0100, Filippo Argiolas wrote:
> > I've also implemented repeated key
> > feature (with repeat delay to avoid unwanted double hits) for rc-5 and
> > nec protocols. It also contains some keymap for the remotes I've used
> > for testing (a philipps compatible rc5 remote and a teac nec remote).
> > They are far from being complete since I've used them just for
> > testing.
> 
> I'm quite interested in testing this patch, key repeats have been a
> nagging thing in the back of my mind.
> 
> I'll be testing this patch, and I'll document it in the wiki here:
> 
> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500
> 
> I have a question about the quoted part.
> 
> Will this mess in any way with the current keycodes of my Nova-T-500
> remote?

As far as I can tell the answer is no since the remotes I've mapped uses
address 0x00 (standard philipps adress for TVs) and 0x72 that are not
used in other keymaps. I cannot test it because I don't have a Hauppauge
remote but I think nothing messy should happen.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
