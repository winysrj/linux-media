Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:8651 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0E1GtC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 02:49:02 -0400
Received: by fg-out-1718.google.com with SMTP id l26so487403fgb.1
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 23:49:01 -0700 (PDT)
Date: Fri, 28 May 2010 08:48:57 +0200
From: Davor Emard <davoremard@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, semirocket@gmail.com
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100528064857.GA7710@lipa.lan>
References: <20100508160628.GA6050@z60m>
 <op.vceiu5q13xmt7q@crni>
 <AANLkTinMYcgG6Ac73Vgdx8NMYocW8Net6_-dMC3yEflQ@mail.gmail.com>
 <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni>
 <20100509173243.GA8227@z60m>
 <op.vcga9rw2ndeod6@crni>
 <20100509184822.GA6340@z60m>
 <20100527141845.200ad4e3@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527141845.200ad4e3@pedra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The IR code suffered a major change during this development cycle. So, this patch doesn't apply
> anymore.

OK, let's delay IR part for a while I'd like to try the new IR code,
mainly because of keystroke loss issue if the new code perhaps
works better.

In this patch is just my suggestion of remote key events to generate, 
(this a MCE alike remote) as you can see I avoided normal key events 
from ordinary keyboard (numeric 0-9) because now in the kernel are more 
suitable events for this for the OS to immediately recognize related 
keypress "1" and start the related application (e.g. TV viewer)

Emard
