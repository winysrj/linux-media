Return-path: <linux-media-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:35264 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbZLCTr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 14:47:56 -0500
Message-ID: <20091203124800.hkb2hbx0gk0o0s0s@webmail.xmission.com>
Date: Thu, 03 Dec 2009 12:48:00 -0700
From: alhaz@xmission.com
To: lirc-list@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-input@vger.kernel.org
References: <4B155288.1060509@redhat.com>
	<20091201201158.GA20335@core.coreip.homeip.net>
	<4B15852D.4050505@redhat.com>
	<20091202093803.GA8656@core.coreip.homeip.net>
	<4B16614A.3000208@redhat.com>
	<20091202171059.GC17839@core.coreip.homeip.net>
	<9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
	<4B16BE6A.7000601@redhat.com>
	<20091202195634.GB22689@core.coreip.homeip.net>
	<2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
	<9e4733910912021620s7a2b09a8v88dd45eef38835a@mail.gmail.com>
In-Reply-To: <9e4733910912021620s7a2b09a8v88dd45eef38835a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Subject: Re: [RFC v2] Another approach to IR
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Jon Smirl <jonsmirl@gmail.com>:

>>> Now I understand that if 2 remotes send completely identical signals we
>>> won't be able to separate them, but in cases when we can I think we
>>> should.
>>
>> I don't have a problem with that, if its a truly desired feature.   
>> But for the most part, I don't see the point. Generally, you go   
>> from having multiple remotes, one per device (where "device" is   
>> your TV, amplifier, set top box, htpc, etc), to having a single   
>> universal remote that controls all of those devices. But for each   
>> device (IR receiver), *one* IR command set. The desire to use   
>> multiple distinct remotes with a single IR receiver doesn't make   
>> sense to me. Perhaps I'm just not creative enough in my use of IR. :)

 From a hobbiest's perspective there's likely rarely any reason to be  
able to do the same thing with two different remotes that send  
different signals, but i could see it come up - For example if you  
wanted to have both a feature-rich,  busy/complicated remote but also  
wanted to provide a simpler remote with a relatively small number of  
large buttons on it for basic functions, as for children or people  
with poor eyesight or poor motor control.

 From a business perspective, I've worked for a company that sold  
turn-key video training systems, and depending on the whims of our  
so-called business partners and the desires of customers, there were  
as many as three distinct remotes that might get shipped with the  
training system, and they all sent different signals.

That was a less than ideal situation, and if we had been really on top  
of things we'd have just declined to use any of those remotes and  
bought custom remotes from any of the numerous vendors that sell them  
which would allow us to have one set of IR signals used by remotes  
with different features - but for whatever reason that wasn't how  
management decided to do things.
