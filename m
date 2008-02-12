Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+0309b135b8e6179adca8+1633+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JOwQW-0000cL-Sz
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 15:48:05 +0100
Date: Tue, 12 Feb 2008 12:47:34 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Richard (MQ)" <osl2008@googlemail.com>
Message-ID: <20080212124734.62cd451d@gaivota>
In-Reply-To: <47AE20BD.7090503@googlemail.com>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sat, 09 Feb 2008 21:53:01 +0000
"Richard (MQ)" <osl2008@googlemail.com> wrote:

> Richard (MQ) wrote:
> > Mauro Carvalho Chehab wrote:
> >> If you're not seeing any mesage from tuner-xc2028, it means that the driver is
> >> selecting a different tuner.
> >>
> >> Please send me the complete dmesg.
> >>
> >> Also, try to force saa7134 driver to use tuner=71 with:
> >>
> >> modprobe -vv saa7134 tuner=71
> > 
> > Please find attached - not posted to list as I don't think everyone will
> > want this...
> 
> Just tried re-booting the box with the standard OpenSuSE 10.3 partition,
> (and completely re-loaded and re-built the mercurial code) - same odd
> behaviour. Kernel now 2.6.22.16 fwiw
> 
> Also may be worth noting - running "make reload" after "make install"
> produces lots of errors, though neither the initial "make" nor "make
> install" gave any.
> 
> Output of "modprobe -vv saa7134 tuner=71" for this case attached
> (smaller than last time!)

The file got corrupted here :(

If you're getting too much errors, it may mean that you're having some
conflicts on your compilation.

There is a recent patch at the tree that changed the module dependencies.
(before the patch, videodev were dependent on v4l2-common - now, the dependency
is the reverse. Only after "make distclean", the building system will
correctly deal with this change)

Please try to do force a cleanup, with this:
make distclean
make
make rminstall
make rmmod
make install
modprobe saa7134 tuner=71

please forward the errors that it might produce. You may forward the full dmesg
errors to me in priv directly. I prefer if you don't generate a tarball, since
makes easier for me to comment, the results, if needed.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
