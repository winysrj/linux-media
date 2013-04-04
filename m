Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41302 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760819Ab3DDNdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 09:33:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH RFC] [media] add Aptina mt9m114 HD digital image sensor driver
Date: Thu, 04 Apr 2013 15:34:51 +0200
Message-ID: <1385456.JiqmfYkIEH@avalon>
In-Reply-To: <CAHG8p1CpeF3BGyVB1pT+brOB+1o1MmuEZuAk+mvDhY_wPYynLA@mail.gmail.com>
References: <1358546444-30265-1-git-send-email-scott.jiang.linux@gmail.com> <1691028.0qtxercLZ8@avalon> <CAHG8p1CpeF3BGyVB1pT+brOB+1o1MmuEZuAk+mvDhY_wPYynLA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Scott,

On Monday 01 April 2013 17:33:02 Scott Jiang wrote:
> Hi Laurent,
> 
> >> >> +struct mt9m114_reg {
> >> >> +     u16 reg;
> >> >> +     u32 val;
> >> >> +     int width;
> >> >> +};
> >> >> +
> >> >> +enum {
> >> >> +     MT9M114_QVGA,
> >> >> +     MT9M114_VGA,
> >> >> +     MT9M114_WVGA,
> >> >> +     MT9M114_720P,
> >> >> +};
> >> > 
> >> > This is the part I don't like. Instead of hardcoding 4 different
> >> > resolutions and using large register address/value tables, you should
> >> > compute the register values from the image size requested by the user.
> >> 
> >> In fact we get this table with the Aptina development tool. So we only
> >> support fixed resolutions. If we compute each register value, it only
> >> makes the code more complex.
> > 
> > But it also makes the code more useful, as the user won't be limited to
> > the 4 resolutions above.
> 
> The problem is Aptina datasheet doesn't tell us how to calculate these
> values. We only have some register presets.

Have you tried requesting the information from Aptina ?

-- 
Regards,

Laurent Pinchart

