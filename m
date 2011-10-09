Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55251 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1JIWfJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 18:35:09 -0400
Received: by yxl31 with SMTP id 31so4881985yxl.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 15:35:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
References: <CA+2YH7t+cHNoV_oNF6cOyTjr+OFbWAAoKCujFwfNHjvijoD8pw@mail.gmail.com>
	<CA+2YH7tv-VVnsoKe+C3es==hmKZw771YvVNL=_wwN=hz7JSKSQ@mail.gmail.com>
	<CAAwP0s0qUvCn+L+tx4NppZknNJ=6aMD5e8E+bLerTnBLLyGL8A@mail.gmail.com>
	<201110081751.38953.laurent.pinchart@ideasonboard.com>
	<CAAwP0s3K8D7-LyVUmbj1tMjU6UPESJPxWJu43P2THz4fDSF41A@mail.gmail.com>
Date: Mon, 10 Oct 2011 00:35:08 +0200
Message-ID: <CA+2YH7vat9iSAuZ4ztDvvo4Od+b4tCOsK6Y+grTE05YUZZEYPQ@mail.gmail.com>
Subject: Re: omap3-isp status
From: Enrico <ebutera@users.berlios.de>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 8, 2011 at 6:11 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> Yes, I'll cook a patch today on top on your omap3isp-yuv and send for
> review. I won't be able to test neither since I don't have proper
> hardware at home. But at least you will get an idea of the approach we
> are using to solve this and can point possible flaws.

I made some tests and unfortunately there are some problems.

Note: i made these tests picking some patches from omap3isp-yuv branch
and applying to igep 3.1.0rc9 kernel (more or less like mainline +
some bsp patches) so maybe i made some mistakes (the tvp5150 driver is
patched too), but due to the nature of the problems i don't think this
is the case.

Javier patches v1: i can grab frames with yavta but i get only garbage.

Javier patches v2: i cannot grab frames with yavta (it hangs). I see
only 2 interrupts on the isp, then stops.

I compared Javier-v2 registers setup with Deepthy's patches and there
are some differences. Moreover i remember that in Deepthy patches vd1
interrupt was not used (and in fact i had the same yavta-hanging
problem before, and Deepthy patches solved it).

I think Javier-v1 patches didn't hang the isp because they changed
vd0/vd1 logic too, so maybe there were only some wrong isp registers
but the logic was correct.

Now i wonder if it could be easier/better to port Deepthy patches
first and then add Javier fixes...

Enrico
