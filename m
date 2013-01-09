Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab3AIKmX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Jan 2013 05:42:23 -0500
Date: Wed, 9 Jan 2013 08:41:43 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Johannes Stezenbach <js@linuxtv.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
Message-ID: <20130109084143.5720a1d6@redhat.com>
In-Reply-To: <50ED3BBB.4040405@schinagl.nl>
References: <507FE752.6010409@schinagl.nl>
	<50D0E7A7.90002@schinagl.nl>
	<50EAA778.6000307@gmail.com>
	<50EAC41D.4040403@schinagl.nl>
	<20130108200149.GB408@linuxtv.org>
	<50ED3BBB.4040405@schinagl.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 09 Jan 2013 10:43:23 +0100
Oliver Schinagl <oliver+list@schinagl.nl> escreveu:

> On 08-01-13 21:01, Johannes Stezenbach wrote:
> > On Mon, Jan 07, 2013 at 01:48:29PM +0100, Oliver Schinagl wrote:
> >> On 07-01-13 11:46, Jiri Slaby wrote:
> >>> On 12/18/2012 11:01 PM, Oliver Schinagl wrote:
> >>>> Unfortunatly, I have had zero replies.
> >>> Hmm, it's sad there is a silence in this thread from linux-media guys :/.
> >> In their defense, they are very very busy people ;) chatter on this
> >> thread does bring it up however.
> > This is such a nice thing to say :-)
> > But it might be that Mauro thinks the dvb-apps maintainer should
> > respond, but apparently there is no dvb-apps maintainer...
> > Maybe you should ask Mauro directly to create an account for you
> > to implement what you proposed.
> Mauro is CC'ed and I'd ask of course for this (I kinda did) but who 
> decides what I suggested is a good idea? I personally obviously think it 
> is ;) and even more so if dvb-apps are unmaintained.
> 
> I guess the question now becomes 'who okay's this change? Who says 
> 'okay, lets do it this way. Once that is answered we can go from there ;)

If I understood it right, you want to split the scan files into a separate
git tree and maintain it, right?

I'm ok with that.

Regards,
Mauro
