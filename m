Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbZDFRpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 13:45:01 -0400
Date: Mon, 6 Apr 2009 14:44:08 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: David Wong <davidtlwong@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX
 China  DMB-TH digital demodulator
Message-ID: <20090406144408.63b2ef71@pedra.chehab.org>
In-Reply-To: <412bdbff0903302154w5ddb3fc8m684bcb5092942561@mail.gmail.com>
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
	<412bdbff0903302154w5ddb3fc8m684bcb5092942561@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 31 Mar 2009 00:54:49 -0400
Devin Heitmueller <devin.heitmueller@gmail.com> wrote:

> On Tue, Mar 17, 2009 at 11:55 AM, David Wong <davidtlwong@gmail.com> wrote:
> > This patch contains the unified driver for Legend Silicon LGS8913 and
> > LGS8GL5. It should replace lgs8gl5.c in media/dvb/frontends
> >
> > David T.L. Wong
> 
> David,
> 
> The questions you posed tonight on a separate thread about making the
> xc5000 work with this device prompts the question:
> 
> Do you know that this driver you submitted actually works?  Have you
> successfully achieved lock with this driver and been able to view the
> stream?
> 
> It is great to see the improvements and more generic support, but if
> you don't have it working in at least one device, then it probably
> shouldn't be submitted upstream yet, and it definitely should not be
> replacing an existing driver.

We need to do some tests before replacing the existing one. Yet, it is better
to have a generic device than specific ones. Do you have any card with lg8gl5?
If so, could you please test the new driver for us?

Anyway, I'm applying what we currently have.

Cheers,
Mauro
