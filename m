Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+b62fe65aec208862d7d2+1778+infradead.org+dwmw2@bombadil.srs.infradead.org>)
	id 1KFVa3-0006jT-Hp
	for linux-dvb@linuxtv.org; Sun, 06 Jul 2008 16:51:11 +0200
From: David Woodhouse <dwmw2@infradead.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0807060729o639f98b1s383d146856feb6da@mail.gmail.com>
References: <1214139259.2994.8.camel@jaswinder.satnam>
	<200807060315.51736@orion.escape-edv.de> <48708BBF.9050400@cadsoft.de>
	<1215343022.10393.945.camel@pmac.infradead.org>
	<412bdbff0807060729o639f98b1s383d146856feb6da@mail.gmail.com>
Date: Sun, 06 Jul 2008 15:48:02 +0100
Message-Id: <1215355682.3189.101.camel@shinybook.infradead.org>
Mime-Version: 1.0
Cc: kernelnewbies <kernelnewbies@nl.linux.org>, linux-dvb@linuxtv.org,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jaswinder Singh <jaswinder@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
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

On Sun, 2008-07-06 at 10:29 -0400, Devin Heitmueller wrote:
> Correct me if I'm wrong, but doesn't this also affect those
> distributions that consider kernels with binary firmware blobs to not
> be free software?  Those distributions take the stance that the
> firmware must be loadable by userland, in which case the proposed
> patch removes this capability.

No, it doesn't remove that capability.

We're just observing that the trick which fdump.c uses to turn firmware
into a hex array in C source is obsoleted by the generic ability to
include firmware blobs into the kernel using CONFIG_EXTRA_FIRMWARE. If
we just use the generic method, then the conditional code in the driver
can go away, as can the fdump tool.

Yes, that does mean that it's either in the _kernel_ or in userspace,
rather than being in the .ko file -- but if you want modularity and are
already depending on having a functional userspace, it doesn't seem to
make a lot of sense to have this reimplementation of generic
functionality, just so that you can keep the two parts in _one_ file.

-- 
dwmw2


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
