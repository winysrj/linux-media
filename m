Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60443 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545AbZIGFKe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 01:10:34 -0400
Date: Mon, 7 Sep 2009 02:10:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: linuxtv-commits@linuxtv.org, Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
 firmware name
Message-ID: <20090907021002.2f4d3a57@caramujo.chehab.org>
In-Reply-To: <37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	<37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 4 Sep 2009 14:05:31 -0400
Michael Krufky <mkrufky@kernellabs.com> escreveu:

> Mauro,
> 
> This fix should really go to Linus before 2.6.31 is released, if
> possible.  It also should be backported to stable, but I need it in
> Linus' tree before it will be accepted into -stable.
> 
> Do you think you can slip this in before the weekend?  As I
> understand, Linus plans to release 2.6.31 on Saturday, September 5th.
> 
> If you dont have time for it, please let me know and I will send it in myself.
> 

This patch doesn't apply upstream:

$ patch -p1 -i 12613.patch
patching file drivers/media/video/cx25840/cx25840-firmware.c
Hunk #5 FAILED at 107.
1 out of 5 hunks FAILED -- saving rejects to file drivers/media/video/cx25840/cx25840-firmware.c.re



Cheers,
Mauro
