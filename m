Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46177 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2JQJy3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:54:29 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so7209004oag.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 02:54:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121017105321.062c898d@pyramind.ukuu.org.uk>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
	<20121016212208.GB10462@morell.nvidia.com>
	<20121017105321.062c898d@pyramind.ukuu.org.uk>
Date: Wed, 17 Oct 2012 19:54:28 +1000
Message-ID: <CAPM=9txT+Wa_JXvsv7O3mqA6WK19z8chvSVxGQdf7R3Xo-mtQg@mail.gmail.com>
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

On Wed, Oct 17, 2012 at 7:53 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I believe that the developers and maintainers of dma-buf have provided
>> the needed signoff, both in person and in this thread.  If there are any
>> objections from that group, I'm happy to discuss any changes necessary to get
>> this merged.
>
> You need the permission of the owners of all the dependant code that
> forms the work. The rules and licence are quite clear, as I think are the
> views of several of the rights holders on both the interpretation and
> intent of the licensing of their code.
>
> Please go and discuss estoppel, wilful infringement and re-licensing with
> your corporate attorneys. If you want to relicense components of the code
> then please take the matter up with the corporate attorneys of the rights
> holders concerned.

Alan please stick with the facts. This isn't a relicense of anything.
EXPORT_SYMBOL_GPL isn't a license its nothing like a license. Its a
totally pointless thing, it should be
EXPORT_SYMBOL_USERS_MIGHT_BE_DERIVED_CONSULT_YOUR_LAWYER, but it
really should be EXPORT_SYMBOL, and really consult your lawyers
anyways.

Dave.
