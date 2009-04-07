Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbZDGCRT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 22:17:19 -0400
Date: Mon, 6 Apr 2009 23:17:02 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Timothy Lee <timothy.lee@siriushk.com>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	David Wong <davidtlwong@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX
 China  DMB-TH digital demodulator
Message-ID: <20090406231702.6b09d190@pedra.chehab.org>
In-Reply-To: <49DAA42C.8070302@siriushk.com>
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
	<412bdbff0903302154w5ddb3fc8m684bcb5092942561@mail.gmail.com>
	<20090406144408.63b2ef71@pedra.chehab.org>
	<49DAA42C.8070302@siriushk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 07 Apr 2009 08:54:04 +0800
Timothy Lee <timothy.lee@siriushk.com> wrote:

> Dear Mauro,
> 
> I wrote the original lgs8gl5 driver by reverse-engineering my USB TV 
> stick using UsbSnoop.
> 
> I've been working together with David to make sure his lgs8gxx driver 
> works with my TV stick, so yes, the generic driver actually works.  :)

Great! You should sign a patch together, removing the legacy module and using
the newer one instead. It would be better to have this merged at the
development tree for a while, to be sure that this won't cause regressions.

Cheers,
Mauro
