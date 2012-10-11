Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49580 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2JKUI0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 16:08:26 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so2171502oag.19
        for <linux-media@vger.kernel.org>; Thu, 11 Oct 2012 13:08:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121011123407.63b5ecbe@pyramind.ukuu.org.uk>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
	<20121011123407.63b5ecbe@pyramind.ukuu.org.uk>
Date: Fri, 12 Oct 2012 06:08:26 +1000
Message-ID: <CAPM=9txkSXAOu5Q_H3LWuMrJ+Q_paLPrORtRuHNg6qvsukNdyw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 11, 2012 at 9:34 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The whole purpose of this API is to let DRM and V4L drivers share buffers for
>> zero-copy pipelines. Unfortunately it is a fact that several popular DRM drivers
>> are closed source. So we have a choice between keeping the export symbols GPL
>> and forcing those closed-source drivers to make their own incompatible API,
>> thus defeating the whole point of DMABUF, or using EXPORT_SYMBOL and letting
>> the closed source vendors worry about the legality. They are already using such
>> functions (at least nvidia is), so they clearly accept that risk.
>
> Then they can accept the risk of ignoring EXPORT_SYMBOL_GPL and
> calling into it anyway can't they. Your argument makes no rational sense
> of any kind.

But then why object to the change, your objection makes sense, naking
the patch makes none, if you believe in your objection.

Also really its just bullshit handwaving all of it, your objection,
_GPL etc. until someone grows a pair and sues someone, instead of
hiding behind their employment status. If you really believed you were
right, you could retire on the settlement payout.

Dave.
