Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40488 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab2JQKID (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 06:08:03 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so7169201obb.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 03:08:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPM=9txT+Wa_JXvsv7O3mqA6WK19z8chvSVxGQdf7R3Xo-mtQg@mail.gmail.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
	<20121016212208.GB10462@morell.nvidia.com>
	<20121017105321.062c898d@pyramind.ukuu.org.uk>
	<CAPM=9txT+Wa_JXvsv7O3mqA6WK19z8chvSVxGQdf7R3Xo-mtQg@mail.gmail.com>
Date: Wed, 17 Oct 2012 20:08:01 +1000
Message-ID: <CAPM=9twQnqzPAH2HF_joXHWY77saQ7eUZanae4GtaeG+8GTP9g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: Use EXPORT_SYMBOL
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Morell <rmorell@nvidia.com>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Please go and discuss estoppel, wilful infringement and re-licensing with
>> your corporate attorneys. If you want to relicense components of the code
>> then please take the matter up with the corporate attorneys of the rights
>> holders concerned.
>
> Alan please stick with the facts. This isn't a relicense of anything.
> EXPORT_SYMBOL_GPL isn't a license its nothing like a license. Its a
> totally pointless thing, it should be
> EXPORT_SYMBOL_USERS_MIGHT_BE_DERIVED_CONSULT_YOUR_LAWYER, but it
> really should be EXPORT_SYMBOL, and really consult your lawyers
> anyways.
>

Also we should look at this
http://lists.linaro.org/pipermail/linaro-mm-sig/2011-September/000616.html

original code posting had no EXPORT_SYMBOL, so the original author's
intents were quite clear.

Dave.
