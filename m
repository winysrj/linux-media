Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:37916 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbbBZXGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 18:06:30 -0500
Received: by qcvx3 with SMTP id x3so11218131qcv.5
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 15:06:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNVS1YCC0LkpT2+piGGL14ALFv0XH-KSN2dP3YeZ2Kr35Q@mail.gmail.com>
References: <54EE90BF.2030602@redmandi.dyndns.org> <CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
 <CACsaVZJ2aP9JAjRZxKv7vrsLce_r0BowfGCBd6c-XLe8PJsS9g@mail.gmail.com> <CALzAhNVS1YCC0LkpT2+piGGL14ALFv0XH-KSN2dP3YeZ2Kr35Q@mail.gmail.com>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Thu, 26 Feb 2015 15:06:09 -0800
Message-ID: <CACsaVZJ-6P9RyOu9DFPq+tvBE++XS8Ye6gLZJpNKcP8ELLw-ug@mail.gmail.com>
Subject: Re: [PATCH] [media] saa7164: use an MSI interrupt when available
To: Steven Toth <stoth@kernellabs.com>
Cc: Steven Toth <stoth@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This isn't my patch, however shouldn't these bridges already exist in
drivers/pci/quirks.c?

Kyle.

On Thu, Feb 26, 2015 at 12:45 PM, Steven Toth <stoth@kernellabs.com> wrote:
>> I am under the impression it was against the spec to have a PCI-E card
>> without MSI support. Wouldn't the fallback code as well work in this
>> regard?
>
> Not if the motherboard MSI implementation is flakey, like we've seen
> in the past with other PCIe bridges and their interaction with root
> controllers. I've actually seen this with some commercial customers
> using the 7164. With this new patch MSI gets enabled, the 'solution'
> doesn't work properly and now we expect users to compile their own
> kernels, just to get back to a previously working solution.
>
> I'm happy to take the patch if the option can be disabled.
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
