Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from tichy.grunau.be ([85.131.189.73])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1LCcyW-0008Pd-7E
	for linux-dvb@linuxtv.org; Tue, 16 Dec 2008 17:40:50 +0100
Received: from aniel.localnet (unknown [78.52.192.69])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tichy.grunau.be (Postfix) with ESMTPSA id B10B5900C1
	for <linux-dvb@linuxtv.org>; Tue, 16 Dec 2008 17:40:54 +0100 (CET)
To: linux-dvb@linuxtv.org
Content-Disposition: inline
From: Janne Grunau <janne-dvb@grunau.be>
Date: Tue, 16 Dec 2008 17:40:59 +0100
MIME-Version: 1.0
Message-Id: <200812161740.59390.janne-dvb@grunau.be>
Subject: Re: [linux-dvb] [PATCH] Convert GP8PSK module to use S2API
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

On Tuesday 16 December 2008 15:20:30 Alan Nisota wrote:
> Alan Nisota wrote:
> > This patch converts the gp8psk module to use the S2API.
> > It pretends to be  DVB-S2 capable in order to allow the various
> > supported modulations (8PSK, QPSK-Turbo, etc), and keep software
> > compatibility with the S2API patches for Mythtv and VDR.
> >
> > Signed-off by: Alan Nisota <alannisota@gmail.com>
>
> Is there anything I need to do to get this committed?

There are a couple of Issues in the patch, see my review

> There are many
> folks using this hardware, who would love to not need to patch their
> kernel to use it.

I would love to see it committed to get rid of the previous EXTENDED_API in 
mythtv.

Janne


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
