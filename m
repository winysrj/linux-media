Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from scing.com ([217.160.110.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <janne-dvb@grunau.be>) id 1KiomY-000319-Sv
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 13:13:16 +0200
From: Janne Grunau <janne-dvb@grunau.be>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Sep 2008 13:13:10 +0200
References: <20080923181628.10797e0b@mchehab.chehab.org>
	<48DB6A94.2040508@linuxtv.org>
	<d9def9db0809250345v674861a0k3d4b5f2c765e4152@mail.gmail.com>
In-Reply-To: <d9def9db0809250345v674861a0k3d4b5f2c765e4152@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809251313.10640.janne-dvb@grunau.be>
Cc: Manu Abraham <abraham.manu@gmail.com>, Greg KH <greg@kroah.com>,
	Michael Krufky <mkrufky@linuxtv.org>, Marcel Siegert <mws@linuxtv.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
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

On Thursday 25 September 2008 12:45:51 Markus Rechberger wrote:
> what's the matter of merging both? please let us discuss that, the
> APIs shouldn't have a big impact on each other.
> Does it break someone's neck to have both?

They will stick both forever in the kernel and either applications or 
drivers have to support both. Realistically both drivers and 
applications will support both.

This is a stupid compromise which doesn't solve anything. A decision was 
made we should live with it.

Janne



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
