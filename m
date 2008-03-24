Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JdmrS-0002GL-Rm
	for linux-dvb@linuxtv.org; Mon, 24 Mar 2008 14:37:15 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id 36EC8D88130
	for <linux-dvb@linuxtv.org>; Mon, 24 Mar 2008 14:36:18 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1206362971.5058.4.camel@anden.nu>
References: <1206139910.12138.34.camel@youkaida> <47E77895.8000708@ivor.org>
	<1206352930.7699.2.camel@acropora> <1206362971.5058.4.camel@anden.nu>
Date: Mon, 24 Mar 2008 13:36:12 +0000
Message-Id: <1206365772.7699.10.camel@acropora>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T-500 disconnects - They are back!
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

On Mon, 2008-03-24 at 13:49 +0100, Jonas Anden wrote:
> A wild guess (bash me on the head if I'm wrong),

Plonk! ;o)

>  but when you switched
> kernel, did you do 'make distclean' in your v4l-dvb directory? Unless
> you do, the code will keep compiling (and installing) for the previous
> kernel, and your new kernel will only use the stock drivers. That
> would
> explain why you're seeing disconnects again. I made that mistake
> once..

I did a distclean, as usual.

Then I did better, I put the whole tree on the side and got a brand new
one.

And still...

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
