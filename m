Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:38226 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZBUUEu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 15:04:50 -0500
Date: Sat, 21 Feb 2009 21:04:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: kilgota@banach.math.auburn.edu
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221210428.15d96814@hyperion.delvare>
In-Reply-To: <alpine.LNX.2.00.0902211008360.9653@banach.math.auburn.edu>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<20090218071041.63c09ba3@pedra.chehab.org>
	<20090218140105.17c86bcb@hyperion.delvare>
	<20090220212327.410a298b@pedra.chehab.org>
	<alpine.LNX.2.00.0902201853040.9018@banach.math.auburn.edu>
	<20090220231820.67ce2899@pedra.chehab.org>
	<alpine.LNX.2.00.0902211008360.9653@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Feb 2009 10:42:17 -0600 (CST), kilgota@banach.math.auburn.edu wrote:
> This is not exactly what I was trying to say. I'll try again.
> 
> 1. Anyone who would call himself a developer will run quite recent kernels 
> without being forced to do so, voluntarily and with pleasure.
> 
> 2. Sometimes the kernel which just came out has a bug. The bug can 
> interfere with current work even though it is from another kernel 
> subsystem. I mentioned a recent example. The problem was in the basic USB 
> area. It specifically related to devices running on alt0 and using a bulk 
> endpoint. I was trying to support a camera that streams on alt0 over the 
> bulk endpoint. Said bug seriously interfered with progress. Who would say 
> that everyone should simultaneously use the same tree, suggests that 
> everyone should simultaneously experience the same set of bugs.
> 
> 3. Because of (2) and for other obvious reasons, the ability to develop 
> a kernel subsystem semi-independently of the latest git tree is a clever 
> and good thing. Why give it up and tie oneself to just one git tree?
> 
> 4. If it were my decision, I probably would not tie myself in knots if 
> something new would "break" a kernel which is more than a couple of 
> versions behind. Right now, this would probably mean I would not care at 
> all what happened to people running 2.6.24.x or older. Furthermore, if 
> what was "broken" was due to a bug in the old kernel, too bad.
> 
> 5. So I would continue to allow flexibility but I would not become 
> extremely concerned if a kernel more than a couple of versions behind 
> would start to have problems. I would try to be nice and let people know, 
> unless they started to shout at me, at which point I  would start to 
> ignore them.
> 
> Probably all of the above would please nobody, and it is a good that I am 
> not in charge of anything.

Actually, it would totally please me :)

-- 
Jean Delvare
