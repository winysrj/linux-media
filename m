Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbZGOSdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 14:33:13 -0400
Date: Wed, 15 Jul 2009 15:32:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oldrich Jedlicka <oldium.pro@seznam.cz>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Ricardo Cerqueira <v4l@cerqueira.org>,
	LMML <linux-media@vger.kernel.org>,
	hermann pitton <hermann-pitton@arcor.de>
Subject: Re: [RFC] SAA713x setting audio capture frequency (ALSA)
Message-ID: <20090715153239.48043b15@pedra.chehab.org>
In-Reply-To: <200907151736.25586.oldium.pro@seznam.cz>
References: <200907121948.39944.oldium.pro@seznam.cz>
	<200907150857.13784.oldium.pro@seznam.cz>
	<20090715055842.42ba195e@pedra.chehab.org>
	<200907151736.25586.oldium.pro@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Jul 2009 17:36:25 +0200
Oldrich Jedlicka <oldium.pro@seznam.cz> escreveu:


> > So, maybe the right thing to do is to report just 32 kHz.
> 
> Exactly. This is what I'm thinking about too. The typical ALSA usage 
> (according to [1]) is:
> 
> 1. open the device
> 2. set parameters of the device
> 3. repeat until not done: read from the device, write to the device
> 4. close the device
> 
> There is nothing in between ALSA and the program, so the frequency change 
> isn't and cannot be propagated from the driver (for this to work there has to 
> be somebody doing the frequency resampling).
> 
> So to have the ability to switch capture sources (the basic ALSA 
> functionality), it is needed to support the same set of frequencies for all 
> the capture sources - 32kHz.
> 
> If we can agree on this, then I have one part of questions closed :-)
> 
> [1] http://www.equalarea.com/paul/alsa-audio.html

Yes, I agree. 

The patch changing this should add a proper description and a source-code
comment explaining why supporting 48kHz is not a good idea.



Cheers,
Mauro
