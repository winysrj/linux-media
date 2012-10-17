Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:65462 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2JQKkD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 06:40:03 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so7239448oag.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 03:40:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121017113802.73a313d6@pyramind.ukuu.org.uk>
References: <1349884592-32485-1-git-send-email-rmorell@nvidia.com>
	<20121010191702.404edace@pyramind.ukuu.org.uk>
	<CAF6AEGvzfr2-QHpX4zwm2EPz-vxCDe9SaLUjo4_Fn7HhjWJFsg@mail.gmail.com>
	<201210110857.15660.hverkuil@xs4all.nl>
	<20121016212208.GB10462@morell.nvidia.com>
	<20121017105321.062c898d@pyramind.ukuu.org.uk>
	<CAPM=9txT+Wa_JXvsv7O3mqA6WK19z8chvSVxGQdf7R3Xo-mtQg@mail.gmail.com>
	<20121017112504.47269452@pyramind.ukuu.org.uk>
	<CAPM=9txQvNgVK824FrT6GD5eZeeaOEPkBzC9sdd9E4tu=ZdPNw@mail.gmail.com>
	<20121017113802.73a313d6@pyramind.ukuu.org.uk>
Date: Wed, 17 Oct 2012 20:40:01 +1000
Message-ID: <CAPM=9tygKJJ0kPP+4vL_xN-2pphCe8-NXzFKc_kJhDPbteSdAQ@mail.gmail.com>
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

> From the fact this patch keeps getting resubmitted despite repeated
> objection I deduce they are in fact of the view it does matter and that
> therefore it is a licensing change and they are scared of the
> consequences of ignoring it.
>

No I think they just want to have to write a pointless hack lie in
their kernel module.

There is no nice way for nvidia developers to say our lawyers don't
think this is a license issues without doing

MODULE_LICENSE("GPL\0 OH NOT WE DIDNT OUR LAWYESR ARE OKAY");

I don't think I'd be going quite into how illegal it is.

The thing is I can't base a useful userspace interface on this, and
since the nvidia driver exists everwhere despite what we'd wish, I'd
rather let the users have some hope of a sane architecture, instead of
nvidia having to replace even more userspace code and kernel code with
their own insane shit.

Dave.
