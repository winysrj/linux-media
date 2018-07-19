Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52757 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbeGSLdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 07:33:13 -0400
Message-ID: <1531997437.3755.7.camel@pengutronix.de>
Subject: Re: [PATCH] media: coda: add missing h.264 levels
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Date: Thu, 19 Jul 2018 12:50:37 +0200
In-Reply-To: <e35a9f6a-4704-29ad-66c5-b17bc71d18ac@xs4all.nl>
References: <20180628110147.24428-1-p.zabel@pengutronix.de>
         <1531996340.3755.5.camel@pengutronix.de>
         <e35a9f6a-4704-29ad-66c5-b17bc71d18ac@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-07-19 at 12:39 +0200, Hans Verkuil wrote:
> On 07/19/18 12:32, Philipp Zabel wrote:
> > Hi,
> > 
> > On Thu, 2018-06-28 at 13:01 +0200, Philipp Zabel wrote:
> > > This enables reordering support for h.264 main profile level 4.2,
> > > 5.0, and 5.1 streams. Even though we likely can't play back such
> > > streams at full speed, we should still recognize them correctly.
> > > 
> > > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > > ---
> > >  drivers/media/platform/coda/coda-h264.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
> > > index 0e27412e01f5..07b4c706504f 100644
> > > --- a/drivers/media/platform/coda/coda-h264.c
> > > +++ b/drivers/media/platform/coda/coda-h264.c
> > > @@ -108,6 +108,9 @@ int coda_h264_level(int level_idc)
> > >  	case 32: return V4L2_MPEG_VIDEO_H264_LEVEL_3_2;
> > >  	case 40: return V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
> > >  	case 41: return V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
> > > +	case 42: return V4L2_MPEG_VIDEO_H264_LEVEL_4_2;
> > > +	case 50: return V4L2_MPEG_VIDEO_H264_LEVEL_5_0;
> > > +	case 51: return V4L2_MPEG_VIDEO_H264_LEVEL_5_1;
> > >  	default: return -EINVAL;
> > >  	}
> > >  }
> > 
> > I've seen that some newer coda patches have been accepted already,
> > maybe this fell through the cracks?
> 
> No, this was part of a pull request of mine posted July 6th which hasn't
> been merged yet (Mauro is traveling with poor internet connectivity). I
> think he's back next week, so hopefully we'll see these pull request merged.

Oh, I have to keep a closer look on the pull requests.
I only checked patchwork. Thank you!

regards
Philipp
