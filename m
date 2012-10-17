Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33528 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab2JQKTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 06:19:33 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so7176746obb.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 03:19:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPM=9twQnqzPAH2HF_joXHWY77saQ7eUZanae4GtaeG+8GTP9g@mail.gmail.com>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
	<20121016212208.GB10462@morell.nvidia.com>
	<20121017105321.062c898d@pyramind.ukuu.org.uk>
	<CAPM=9txT+Wa_JXvsv7O3mqA6WK19z8chvSVxGQdf7R3Xo-mtQg@mail.gmail.com>
	<CAPM=9twQnqzPAH2HF_joXHWY77saQ7eUZanae4GtaeG+8GTP9g@mail.gmail.com>
Date: Wed, 17 Oct 2012 20:19:33 +1000
Message-ID: <CAPM=9twgpDaMiMTPN4YzOJn41bAsHa2AtpK=EpmqD_KSMrtK9g@mail.gmail.com>
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

b>>
>> Alan please stick with the facts. This isn't a relicense of anything.
>> EXPORT_SYMBOL_GPL isn't a license its nothing like a license. Its a
>> totally pointless thing, it should be
>> EXPORT_SYMBOL_USERS_MIGHT_BE_DERIVED_CONSULT_YOUR_LAWYER, but it
>> really should be EXPORT_SYMBOL, and really consult your lawyers
>> anyways.
>>
>
> Also we should look at this
> http://lists.linaro.org/pipermail/linaro-mm-sig/2011-September/000616.html
>
> original code posting had no EXPORT_SYMBOL, so the original author's
> intents were quite clear.

Yeah so a history research shows this didn't change until v3 of the
code base, and I don't think any lawyers were consulted about changing
the exports then, so I don't see why we should need any now. If we do
need some now, then we needed some then thus making the original
change of the exports a problem.

Now how do I withdraw a Signed-off-by and have dma-buf removed from the kernel?

(not I'm just spouting bullshit here which has as much value as
Alan's, as I said before unless someone grows a pair and sues someone
its all just IANAL and humble opinions.)

Dave.
