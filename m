Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZIGVmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 17:42:09 -0400
Date: Mon, 7 Sep 2009 18:41:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mike Isely <isely@isely.net>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Michael Krufky <mkrufky@kernellabs.com>,
	linuxtv-commits@linuxtv.org, Jarod Wilson <jarod@wilsonet.com>,
	Hans Verkuil via Mercurial <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mike Isely <isely@isely.net>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] cx25840: fix determining the
 firmware name
Message-ID: <20090907184136.4bd36f23@caramujo.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0909071339100.23768@cnc.isely.net>
References: <E1MiTfS-0001LQ-SU@mail.linuxtv.org>
	<37219a840909041105u7fe714aala56893566d93cdc3@mail.gmail.com>
	<20090907021002.2f4d3a57@caramujo.chehab.org>
	<37219a840909062220p3ae71dc0t4df96fd140c5c7b4@mail.gmail.com>
	<20090907030652.04e2d2a3@caramujo.chehab.org>
	<8103ad500909070044r3a04d36bu80e65357ceaf533@mail.gmail.com>
	<20090907095326.3cb7a3d0@caramujo.chehab.org>
	<Pine.LNX.4.64.0909071339100.23768@cnc.isely.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 Sep 2009 13:42:15 -0500 (CDT)
Mike Isely <isely@isely.net> escreveu:

> On Mon, 7 Sep 2009, Mauro Carvalho Chehab wrote:
> 
> 
>    [...]
> 
> > 
> > I remember I asked both Mikes (Michael Krufky and Mike Isely) on March for some
> > tests with the new firmware. I'm not sure if they had some time for testing it.
> 
> Yes, I remember this exchange.  At the time you had mentioned only the 3 
> files with identical MD5 sums (not that other one with the dadb79... 
> sum).  Here's the message I sent in response at that time:

Hmm... I never received your answer, sorry. Probably some email issue.

> 
> <CUT_HERE>
> 
> From isely@isely.net Tue Mar 31 21:17:58 2009
> From: Mike Isely <isely@isely.net>
> To: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>, Michael Krufky <mkrufky@linuxtv.org>, Mike Isely at pobox <isely@pobox.com>
> Date: Tue, 31 Mar 2009 21:17:54 -0500 (CDT)
> Subject: Re: Conexant firmwares
> Reply-To: Mike Isely <isely@pobox.com>
> 
> On Tue, 24 Mar 2009, Mike Isely wrote:
> 
> > On Mon, 23 Mar 2009, Mauro Carvalho Chehab wrote:
> > 
> > > Hi Hans and Mike I.,
> > > 
> > > Conexant officially sent us their firmwares. Due to that, I've added the
> > > firmwares at linuxtv.org and included at the get_dvb_firmware script. 
> > > 
> > > I'll also make sure that they'll be added at kernel-firmware -git and
> > > included in Fedora.
> > > 
> > > As Michael K. noticed, the cx25840 firmwares are identical, for 3 different
> > > models:
> > > 
> > > a9f8f5d901a7fb42f552e1ee6384f3bb  cx23885 firmware/v4l-cx23885-enc.fw
> > > a9f8f5d901a7fb42f552e1ee6384f3bb  cx25840 firmwares/v4l-cx231xx-avcore-01.fw
> > > a9f8f5d901a7fb42f552e1ee6384f3bb  cx25840 firmwares/v4l-cx23885-avcore-01.fw
> > > 
> > > Could you please test if those firmwares work well for the ivtv and pvrusb2
> > > models? 
> > > 
> > > All those firmwares are available at linuxtv.org downloads/firmware dir.
> > > 
> > 
> > I imagine that they will all work just fine.  But I'll let you know once 
> > I've positively verified that fact.
> > 
> >   -Mike
> 
> Yes, it works fine.  I tested an HVR-1950 and a PVR-USB2 24xxx series 
> model.  Both work with the new firmware.
> 
> Given that the 3 firmware images are identical, then what's the point of 
> there being 3 different names?

Good to know!
> 
>   -Mike
> 
> </CUT_HERE>

> 
> 




Cheers,
Mauro
