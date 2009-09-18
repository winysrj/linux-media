Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZIRFMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Sep 2009 01:12:18 -0400
Date: Fri, 18 Sep 2009 02:11:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Media Controller initial support for ALSA devices
Message-ID: <20090918021141.2819e380@pedra.chehab.org>
In-Reply-To: <829197380909172140q124ce047nd45ad5d64b155fb3@mail.gmail.com>
References: <829197380909172140q124ce047nd45ad5d64b155fb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Sep 2009 00:40:34 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Hello Hans,
> 
> If you can find a few minutes, please take a look at the following
> tree, where I added initial support for including the ALSA devices in
> the MC enumeration.  I also did a bit of cleanup on your example tool,
> properly showing the fields associated with the given node type and
> subtype (before it was always showing fields for the V4L subtype).
> 
> http://kernellabs.com/hg/~dheitmueller/v4l-dvb-mc-alsa/
> 
> I've implemented it for em28xx as a prototype, and will probably see
> how the code looks when calling it from au0828 and cx88 as well (to
> judge the quality of the abstraction).
> 
> Comments welcome, of course...

How do you expect that em28xx devices using snd-usb-audio to be enumerated?



Cheers,
Mauro
