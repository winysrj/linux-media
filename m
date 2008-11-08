Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6fd8abdcad2e3524d151+1903+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KylCt-0007Qs-P2
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 11:38:20 +0100
Date: Sat, 8 Nov 2008 05:37:45 -0500 (EST)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@gmail.com>
In-Reply-To: <d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811080529000.7489@bombadil.infradead.org>
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	<200811011459.17706.hverkuil@xs4all.nl>
	<20081102022728.68e5e564@pedra.chehab.org>
	<a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
	<20081108081508.496f6582@pedra.chehab.org>
	<d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
MIME-Version: 1.0
Cc: v4l <video4linux-list@redhat.com>, Vitaly Wool <vwool@ru.mvista.com>,
	Dan Kreiser <kreiser@informatik.hu-berlin.de>,
	Lukas Kuna <lukas.kuna@evkanet.net>,
	Andre Kelmanson <akelmanson@gmail.com>, acano@fastmail.fm,
	John Stowers <john.stowers.lists@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>,
	Zhenyu Wang <zhen78@gmail.com>, linux-dvb@linuxtv.org,
	em28xx <em28xx@mcentral.de>, greg@kroah.com,
	Stefan Vonolfen <stefan.vonolfen@gmail.com>,
	Stephan Berberig <s.berberig@arcor.de>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Frank Neuber <fn@kernelport.de>
Subject: Re: [linux-dvb] [PATCH 1/7] Adding empia base driver
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

On Sat, 8 Nov 2008, Markus Rechberger wrote:

> As written earlier already I don't think that I didn't follow any
> rules here since I provided single
> patches at the very first beginning
>
> http://mcentral.de/v4l-dvb/
> (this is all kernel code and only kernel code).
>
> That work didn't get attention and due a different decision of
> framework changes (which that codebase relied
> on) it all had to be rebased, I doubt that anyone
> would have reworked all that patch for patch. Instead it went into one
> repository and finally got modified to work again
> with the available framework rather than relying onto any such modifications.

One thing is to rebase a tree, another is to merge all patches into a big 
one, not preserving the original authorships.

Development trees sometimes need rebase. This is done by popping all newer 
patches from the tree, applying the upstream patches, and then pushing 
again every individual patches, fixing the ones that don't apply well, but 
preserving their authorships.

The modified patches should receive a special tag before the 
maintainer's SOB, like:

[me@mymail: I did this to apply this patch]

as stated at the kernel docs.

This method will reduce a lot the risk of breaking improvements and other 
fixes that happened upstream, and will properly preserve authorship of 
individual patches.

If you were doing a rebase, your patches would likely be accepted.

-- 
Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
