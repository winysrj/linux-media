Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43242 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbeJICNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2018 22:13:52 -0400
Date: Mon, 8 Oct 2018 16:00:29 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, tfiga@chromium.org,
        jcliang@chromium.org, shik@chromium.org
Subject: Re: [PATCH] media: vivid: Support 480p for webcam capture
Message-ID: <20181008160029.1bd1f5a8@coco.lan>
In-Reply-To: <931ca67d-3ac6-afc1-f933-c9733d561767@xs4all.nl>
References: <20181003070656.193854-1-keiichiw@chromium.org>
        <b2dc51d7-fc92-2e7b-3a07-55a076b95d8b@ideasonboard.com>
        <20181008140302.2239633f@coco.lan>
        <00b0a8af-b7a5-cb49-0684-0fd0efefa196@xs4all.nl>
        <20181008152348.7ef6d77e@coco.lan>
        <931ca67d-3ac6-afc1-f933-c9733d561767@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 8 Oct 2018 20:31:10 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > (gdb) list *vivid_fillbuff+0x1e9b
> > 0x1936b is in vivid_fillbuff (drivers/media/platform/vivid/vivid-kthread-cap.c:495).
> > 490					ms % 1000,
> > 491					buf->vb.sequence,
> > 492					(dev->field_cap == V4L2_FIELD_ALTERNATE) ?
> > 493						(buf->vb.field == V4L2_FIELD_TOP ?
> > 494						 " top" : " bottom") : "");
> > 495			tpg_gen_text(tpg, basep, line++ * line_height, 16, str);
> > 496		}
> > 497		if (dev->osd_mode == 0) {
> > 498			snprintf(str, sizeof(str), " %dx%d, input %d ",
> > 499					dev->src_rect.width, dev->src_rect.height, dev->input);
> >   
> 
> There is a bug with hflip handling in that function. Nothing to do with the
> resolution. I could reproduce it by just checking the hflip control.
> I'll investigate.

Ah! Well, as I said, I got it only once last week while trying to use
vivid for some event racing test. I didn't have time to actually
seek. On that time, the bug only manifested when I changed the frame
rate.

Thanks,
Mauro
