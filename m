Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53571 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab3D2U6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 16:58:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH RFC] [media] add Aptina mt9m114 HD digital image sensor driver
Date: Mon, 29 Apr 2013 22:58:58 +0200
Message-ID: <2197086.VBJPhOlmgL@avalon>
In-Reply-To: <CAHG8p1DdY=j1VJH0XdkK8TgYD8sSXvG7u2coX_BwrFB-uUzL5A@mail.gmail.com>
References: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com> <1385456.JiqmfYkIEH@avalon> <CAHG8p1DdY=j1VJH0XdkK8TgYD8sSXvG7u2coX_BwrFB-uUzL5A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

Sorry for the (very) late reply.

On Sunday 07 April 2013 18:35:54 Scott Jiang wrote:
> Hi Laurent,
> 
> >> >> >> +struct mt9m114_reg {
> >> >> >> +     u16 reg;
> >> >> >> +     u32 val;
> >> >> >> +     int width;
> >> >> >> +};
> >> >> >> +
> >> >> >> +enum {
> >> >> >> +     MT9M114_QVGA,
> >> >> >> +     MT9M114_VGA,
> >> >> >> +     MT9M114_WVGA,
> >> >> >> +     MT9M114_720P,
> >> >> >> +};
> >> >> > 
> >> >> > This is the part I don't like. Instead of hardcoding 4 different
> >> >> > resolutions and using large register address/value tables, you
> >> >> > should compute the register values from the image size requested by
> >> >> > the user.
> >> >> 
> >> >> In fact we get this table with the Aptina development tool. So we only
> >> >> support fixed resolutions. If we compute each register value, it only
> >> >> makes the code more complex.
> >> > 
> >> > But it also makes the code more useful, as the user won't be limited to
> >> > the 4 resolutions above.
> >> 
> >> The problem is Aptina datasheet doesn't tell us how to calculate these
> >> values. We only have some register presets.
> > 
> > Have you tried requesting the information from Aptina ?
> 
> No, there is only a datasheet on its website. I refer to register
> definition from Andrew Chew on  this website :
> http://git.chromium.org/gitweb/?p=chromiumos/third_party/kernel-next.git;a=b
> lob;f=drivers/media/video/mt9m114.c;h=a5d2724005e7863607ffe204eefabfb0fad4da
> 46. Even if we have any NDA docs, we can't use it in open source code.

Aptina is actually pretty supportive, I'm quite sure you could get 
documentation under an NDA with an authorization to release the driver source 
code.

-- 
Regards,

Laurent Pinchart

