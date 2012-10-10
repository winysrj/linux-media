Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36388 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761Ab2JJXWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 19:22:35 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so1135170oag.19
        for <linux-media@vger.kernel.org>; Wed, 10 Oct 2012 16:22:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121010191702.404edace@pyramind.ukuu.org.uk>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
Date: Thu, 11 Oct 2012 09:22:34 +1000
Message-ID: <CAPM=9tzQohMuC4SKTzVWoj2WdiZ8EVBpwgD38wNb3T1bNoZjbQ@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Morell <rmorell@nvidia.com>, linaro-mm-sig@lists.linaro.org,
	rob@ti.com, Sumit Semwal <sumit.semwal@linaro.org>,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 11, 2012 at 4:17 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 10 Oct 2012 08:56:32 -0700
> Robert Morell <rmorell@nvidia.com> wrote:
>
>> EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
>> issue, and not really an interface".  The dma-buf infrastructure is
>> explicitly intended as an interface between modules/drivers, so it
>> should use EXPORT_SYMBOL instead.
>
> NAK. This needs at the very least the approval of all rights holders for
> the files concerned and all code exposed by this change.

I think he has that. Maybe he just needs to list them. But this
doesn't change the license on the code at all really, so its actually
not like a re-license where you need approval.

But in any case I personally don't care about this interface being
used if the alternative is they do it themselves. I'm still not going
to debug things with a binary module taint.

Dave.
