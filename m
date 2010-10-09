Return-path: <mchehab@pedra>
Received: from utopia.booyaka.com ([72.9.107.138]:45339 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0JIPK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 11:10:28 -0400
Date: Sat, 9 Oct 2010 09:10:27 -0600 (MDT)
From: Paul Walmsley <paul@booyaka.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L/DVB: tvp5150: COMPOSITE0 input should not force-enable
 TV mode
In-Reply-To: <4CB06806.2070900@infradead.org>
Message-ID: <alpine.DEB.2.00.1010090907180.15379@utopia.booyaka.com>
References: <alpine.DEB.2.00.1010082229160.15379@utopia.booyaka.com> <AANLkTinhS=GOV=1uR6H=9_=S-nyirdm6Z7HF6N5wKw2T@mail.gmail.com> <4CB06806.2070900@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 9 Oct 2010, Mauro Carvalho Chehab wrote:

> Yeah. I basically asked people to do more tests, but never got any feedback
> about that issue. Provided that it won't break anything, I'm ok on merging
> it.

I did also observe that the digital still frame that the EV-S2000 
generates is displayed cleanly both before and after the patch.  Probably 
the signal that it generates in that case is much closer to what the 
TVP5150 expects from "TV mode".


- Paul
