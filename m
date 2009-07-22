Return-path: <linux-media-owner@vger.kernel.org>
Received: from ozgw.promptu.com ([203.144.27.9]:1469 "EHLO
	surfers.oz.promptu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751406AbZGVBsY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 21:48:24 -0400
Received: from pacific.oz.agile.tv (pacific.oz.promptu.com [192.168.16.16])
	by surfers.oz.promptu.com (Postfix) with SMTP id 2D59BA65E6
	for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 11:48:06 +1000 (EST)
Date: Wed, 22 Jul 2009 11:48:06 +1000
From: Bob Hepple <bhepple@promptu.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb: make digital side of pcHDTV HD-3000 functional
 again
Message-Id: <20090722114806.39c8c1ea.bhepple@promptu.com>
In-Reply-To: <200907212135.47557.jarod@redhat.com>
References: <200907201020.47581.jarod@redhat.com>
	<200907201650.23749.jarod@redhat.com>
	<4A65CF79.1040703@kernellabs.com>
	<200907212135.47557.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Jul 2009 21:35:47 -0400
Jarod Wilson <jarod@redhat.com> wrote:

> So its either I have *two* machines with bad, but only slightly bad,
> and in the same way, PCI slots which seem to work fine with any other
> card I have (uh, unlikely), 

... not unlikely if the two machines are similar - many motherboards
have borked PCI slots in one way or another - design faults or
idiosyncratic interpretation of the PCI standard.  I've seen it with
HP, Compaq, Digital m/bs just to name big names, smaller mfrs also get
it wrong. Sometimes just using another slot helps. Sometimes you need
to try a totally different motherboard.

Maybe wrong to 'blame' the m/b mfr - it could just as easily be an
out-of-spec or creatively interpreted PCI standard on the card.



Cheers


Bob

-- 
Bob Hepple <bhepple@promptu.com>
ph: 07-5584-5908 Fx: 07-5575-9550
