Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36573 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbcAEG44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 01:56:56 -0500
Received: by mail-io0-f177.google.com with SMTP id o67so457783930iof.3
        for <linux-media@vger.kernel.org>; Mon, 04 Jan 2016 22:56:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhK7f4kLYaTw874g4w2vjd5nw_FBET1JsjX9Us30Eve5GQ@mail.gmail.com>
References: <CAJ2oMhK7f4kLYaTw874g4w2vjd5nw_FBET1JsjX9Us30Eve5GQ@mail.gmail.com>
Date: Tue, 5 Jan 2016 08:56:55 +0200
Message-ID: <CAJ2oMh+kZoXfKruDAdioVB-3rommkoXRJZU83w5FoVMmv90AnA@mail.gmail.com>
Subject: Re: CMA usage in driver
From: Ran Shalit <ranshalit@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 2, 2016 at 11:23 PM, Ran Shalit <ranshalit@gmail.com> wrote:
> Hello,
>
> I made some reading on CMA usage with device driver, nut not quite sure yet.
> Do we need to call dma_declare_contiguous or does it get called from
> within videobuf2 ?
>
> Is there any example how to use CMA memory in v4l2 driver ?
>

Hi,

just to make the above question simpler:
from a v4l2 driver perspective, when need large contigious dma
allocations are required,
what should matter, and do we need to use CMA and how ?

Thank you for the time,
Ran
