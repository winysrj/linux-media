Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34528 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbZFCMWb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2009 08:22:31 -0400
Date: Wed, 3 Jun 2009 09:22:29 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Wong <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC] Analog Device ADMTV 102 silicon tuner support patch
Message-ID: <20090603092229.787014eb@pedra.chehab.org>
In-Reply-To: <15ed362e0906021913r7683ac62n411a5d2e6bd9ad17@mail.gmail.com>
References: <15ed362e0906021913r7683ac62n411a5d2e6bd9ad17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 3 Jun 2009 10:13:22 +0800
David Wong <davidtlwong@gmail.com> escreveu:

> Hi all,
> 
>   This ADMTV102 tuner code is grab from open sourced driver for
> MyCinema U3100 Mini DMB-TH from ASUS.
> I made some clean up to separate the tuner code from demod code.
> 
>   The original driver author cannot be reached, so I don't know should
> I declare the copyright.

This is probably the most important thing to do: we should be sure that
the driver doesn't have any licensing troubles, since you'll need to testify it
via Signed-off-by. So, if you couldn't find the original author, you may try to
reach the companies envolved, e. g. the distro kernel people, Asus and Analog
Device, asking for their SOB at the original driver.

Also, if the driver is authored by Oliver, as stated at the .h comment:

+ *  Driver for Analog Device ADMTV102 silicon tuner
+ *
+ *  Copyright (c) 2006 Olivier DANET <odanet@caramail.com>

You should preserve his name at the meta-tags, instead of:

+MODULE_AUTHOR("David T.L. Wong");

(or, if you made significant changes, it is OK to add your name, without
suppressing the original author's name)

Another important point: when committing such drivers, the better is to add the
first patch (without Kconfig/Makefile changes) as-is, and then write a second
patch with your changes. This helps to have a clearer boundary line about your
contributions. The last patch should be the Kconfig/Makefile changes. This
helps to avoid trying to build a driver that may not compile well, due to some
API changes, for example, that needs to be fixed during the upstream merging
phase.

> Please comment.
> 
> Regards,
> David T.L. Wong




Cheers,
Mauro
