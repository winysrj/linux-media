Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41134 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbbCIQoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 12:44:00 -0400
Message-ID: <1425919423.1421.14.camel@hadess.net>
Subject: Re: [RFC v2 2/7] media: rc: Add cec protocol handling
From: Bastien Nocera <hadess@hadess.net>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Mauro Carvalho Chehab' <mchehab@osg.samsung.com>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, linux-input@vger.kernel.org
Date: Mon, 09 Mar 2015 17:43:43 +0100
In-Reply-To: <000801d05a85$2c83f4e0$858bdea0$%debski@samsung.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
	 <1421942679-23609-3-git-send-email-k.debski@samsung.com>
	 <20150308112033.7d807164@recife.lan>
	 <000801d05a85$2c83f4e0$858bdea0$%debski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2015-03-09 at 17:22 +0100, Kamil Debski wrote:
> Hi Mauro,
> 
> From: Mauro Carvalho Chehab [mailto:mchehab@osg.samsung.com]
> Sent: Sunday, March 08, 2015 3:21 PM
> 
> > Em Thu, 22 Jan 2015 17:04:34 +0100
> > Kamil Debski <k.debski@samsung.com> escreveu:
> > 
> > (c/c linux-input ML)
> > 
> > > Add cec protocol handling the RC framework.
> > 
> > I added some comments, that reflects my understanding from what's 
> > there at the keymap definitions found at:
> >         http://xtreamerdev.googlecode.com/files/CEC_Specs.pdf
> 
> Thank you very much for the review, Mauro. Your comments are very 
> much appreciated.

How does one use this new support? If I plug in my laptop to my TV, 
will using the TV's remote automatically send those key events to the 
laptop?

Cheers
