Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f52.google.com ([209.85.213.52]:39452 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbbBZUpB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 15:45:01 -0500
Received: by yhab6 with SMTP id b6so5873764yha.6
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 12:45:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACsaVZJ2aP9JAjRZxKv7vrsLce_r0BowfGCBd6c-XLe8PJsS9g@mail.gmail.com>
References: <54EE90BF.2030602@redmandi.dyndns.org>
	<CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
	<CACsaVZJ2aP9JAjRZxKv7vrsLce_r0BowfGCBd6c-XLe8PJsS9g@mail.gmail.com>
Date: Thu, 26 Feb 2015 15:45:00 -0500
Message-ID: <CALzAhNVS1YCC0LkpT2+piGGL14ALFv0XH-KSN2dP3YeZ2Kr35Q@mail.gmail.com>
Subject: Re: [PATCH] [media] saa7164: use an MSI interrupt when available
From: Steven Toth <stoth@kernellabs.com>
To: Kyle Sanderson <kyle.leet@gmail.com>
Cc: Steven Toth <stoth@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I am under the impression it was against the spec to have a PCI-E card
> without MSI support. Wouldn't the fallback code as well work in this
> regard?

Not if the motherboard MSI implementation is flakey, like we've seen
in the past with other PCIe bridges and their interaction with root
controllers. I've actually seen this with some commercial customers
using the 7164. With this new patch MSI gets enabled, the 'solution'
doesn't work properly and now we expect users to compile their own
kernels, just to get back to a previously working solution.

I'm happy to take the patch if the option can be disabled.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
