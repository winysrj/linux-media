Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbZJ0KM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 06:12:29 -0400
Date: Tue, 27 Oct 2009 08:11:55 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: KS Ng <ksnggm@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: failure to submit first post
Message-ID: <20091027081155.05927ad4@pedra.chehab.org>
In-Reply-To: <4AE5A2F3.1060504@gmail.com>
References: <4AE4541D.7060206@gmail.com>
	<4AE5A2F3.1060504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 26 Oct 2009 21:24:03 +0800
KS Ng <ksnggm@gmail.com> escreveu:

> This is a resend with the patch attached.
> 
> KS Ng wrote:
> > Hi,
> >
> > I've registered to linux-media mailing list a couple of days ago and 
> > attempted to do my first posting yesterday with subject "Support for 
> > Magicpro proHDTV Dual DMB-TH adapter". However I can't see my posting 
> > even though I've replied to the email requesting confirmation.
> >
> > Would you please kindly have a look!

Please take a look at:
	http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches

for some comments about how to submit a patch.

Basically, you'll need to send a patch with a short description at the subject,
a more complete description at the body and add your Signed-off-by: there.

Also, please run checkpatch before submitting it, since it will point you the CodingStyle
troubles that your code have. There are several coding styles there, being harder for people
to analyse your code.

In the case of tuner_init_pkts, is this a firmware or just register sets? If it
is a firmware, it should be split from the code, due to legal issues.
Basically, some lawyers believe that, if you distribute a firmware inside of
the source code of a GPL'd code, you're bound to distribute also the firmware
source code, due to GPL.

Cheers,
Mauro.

> >
> > Thanks,
> > K.S. Ng
> >
> > email: ksnggm@gmail.com
> 




Cheers,
Mauro
