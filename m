Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+158cd650765be5afa30f+1779+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KFxrA-0001cW-Np
	for linux-dvb@linuxtv.org; Mon, 07 Jul 2008 23:02:44 +0200
Date: Mon, 7 Jul 2008 18:02:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oliver Endriss <o.endriss@gmx.de>
Message-ID: <20080707180222.4b4a53a9@gaivota>
In-Reply-To: <200807060315.51736@orion.escape-edv.de>
References: <1214139259.2994.8.camel@jaswinder.satnam>
	<200807060315.51736@orion.escape-edv.de>
Mime-Version: 1.0
Cc: kernelnewbies <kernelnewbies@nl.linux.org>,
	David Woodhouse <dwmw2@infradead.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Jaswinder Singh <jaswinder@infradead.org>, linux-dvb@linuxtv.org,
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

Hi Oliver,

> @Mauro:
> Is there a way to strip this stuff from Kconfig/Makefile/av7110*.[ch]
> for submission to the kernel? Basically I don't care whether and how
> they cripple the driver in the kernel. But I would like to keep the code
> 'as is' in the linuxtv repositories.

Having a binary firmware inside a GPL'd file seems to be (at least for some
people) a GPL violation, since the firmware source code should also be released
with GPL (please read [1] for a good article about this).

This seems to be one of the reasons for moving all firmwares that are still in
kernel into a separate dir. A latter step seems to move those files to a cousin
tree, hosted together with kernel tree, and clearly stating that those
firmwares are not GPL, but are allowed to be used with Linux. 

IANAL, but, if the firmware is violating GPL at Kernel, the same violation also
affects our tree. So, from legal POV, I think we ought to do the same thing at
V4L/DVB. 

Probably, it is safe to keep the firmware files into a separate dir,
if we state clearly that the firmwares are not GPL.

Anyway, let's see how we can handle it after having those patches merged at
mainstream.

[1] http://lwn.net/Articles/284932/

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
