Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45651 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3C1JJa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Mar 2013 05:09:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH RFC] [media] add Aptina mt9m114 HD digital image sensor driver
Date: Thu, 28 Mar 2013 10:10:19 +0100
Message-ID: <1691028.0qtxercLZ8@avalon>
In-Reply-To: <CAHG8p1CP8nSjVFeus17wDfiSgq1qTMDDvAJtJODmt5OxL3zj=A@mail.gmail.com>
References: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com> <3061473.pZdeCOpV7t@avalon> <CAHG8p1CP8nSjVFeus17wDfiSgq1qTMDDvAJtJODmt5OxL3zj=A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On Thursday 28 March 2013 16:29:30 Scott Jiang wrote:
> >> This driver support parallel data output mode and
> >> QVGA/VGA/WVGA/720P resolution. You can select YCbCr and RGB565
> >> output format.
> > 
> > What host bridge do you use this driver with ?
> 
> I only tested with blackfin.
> 
> >> + */
> > 
> > [snip]
> > 
> >> +struct mt9m114_reg {
> >> +     u16 reg;
> >> +     u32 val;
> >> +     int width;
> >> +};
> >> +
> >> +enum {
> >> +     MT9M114_QVGA,
> >> +     MT9M114_VGA,
> >> +     MT9M114_WVGA,
> >> +     MT9M114_720P,
> >> +};
> > 
> > This is the part I don't like. Instead of hardcoding 4 different
> > resolutions and using large register address/value tables, you should
> > compute the register values from the image size requested by the user.
> 
> In fact we get this table with the Aptina development tool. So we only
> support fixed resolutions. If we compute each register value, it only makes
> the code more complex.

But it also makes the code more useful, as the user won't be limited to the 4 
resolutions above.

-- 
Regards,

Laurent Pinchart

