Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZDGKu4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Apr 2009 06:50:56 -0400
Date: Tue, 7 Apr 2009 07:50:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [RFC] Anticipating lirc breakage
Message-ID: <20090407075029.21d14f4a@pedra.chehab.org>
In-Reply-To: <20090407120209.1d42bacd@hyperion.delvare>
References: <20090406174448.118f574e@hyperion.delvare>
	<Pine.LNX.4.64.0904070049470.2076@cnc.isely.net>
	<20090407120209.1d42bacd@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Apr 2009 12:02:09 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Mike,
> 
> Glad to see we all mostly agree on what to do now. I'll still answer
> some of your questions below, to clarify things even more.

I don't understand why you are preferring to do some workaround, spending
energy to add hooks at the kernel drivers to support out-of-tree drivers,
instead of working to provide the proper solution.

I'm against adding any hook on kernel to support an out-of-tree driver.

>From what I understood, lirc developers are interested on merging lirc drivers.
We all agree that ir-kbd-i2c doesn't address all i2c IR's, and that lirc
drivers provide support for the remaining ones.

So, let's just forget the workarounds and go straight to the point: focus on
merging lirc-i2c drivers.

Cheers,
Mauro
