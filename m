Return-path: <linux-media-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:34083 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZISKIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 06:08:07 -0400
Date: Sat, 19 Sep 2009 12:08:09 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	jirislaby@gmail.com
Subject: Re: V4L2 drivers: potentially dangerous and inefficient
	msecs_to_jiffies() calculation
Message-ID: <20090919100809.GA22683@rhlx01.hs-esslingen.de>
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de> <4AAFE78B.6060606@gmail.com> <20090915192146.GA18002@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915192146.GA18002@rhlx01.hs-esslingen.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Tue, Sep 15, 2009 at 09:21:46PM +0200, Andreas Mohr wrote:
> Hi,
> 
> On Tue, Sep 15, 2009 at 09:14:19PM +0200, Marcin Slusarz wrote:
> > Or better: frame_timeout * HZ
> 
> D'oh! ;-)
> 
> But then what about the other 3 bazillion places in the kernel
> doing multiples of seconds?
> 
> linux-2.6.31]$ find . -name "*.c"|xargs grep msecs_to_jiffies|grep 1000|wc -l
> 73
> 
> If this expression is really better (also/especially from a maintenance POV),
> then it should get changed.

I just saw that my unmodified patch has been committed.
I think that that is ok or even preferrable, since "HZ" is a lot
less greppable (you'd have to use "\<HZ\>") or uniform than msecs_to_jiffies.
In terms of "number of traps avoided" the expressions should be equivalent.

Thanks!

Andreas Mohr
