Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37436 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1ITWXQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 18:23:16 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/3] v4l: Extend V4L2_CID_COLORFX control with AQUA effect
Date: Wed, 21 Sep 2011 00:23:21 +0200
Cc: Subash Patel <subashrp@gmail.com>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
References: <1316192730-18099-1-git-send-email-s.nawrocki@samsung.com> <4E76DC47.7050106@gmail.com> <4E7726EF.7050003@samsung.com>
In-Reply-To: <4E7726EF.7050003@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109210023.21478.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Monday 19 September 2011 13:26:39 Sylwester Nawrocki wrote:
> On 09/19/2011 08:08 AM, Subash Patel wrote:
> > Hi Laurent,
> > 
> > I am not representing Sylwester :), But with a similar sensor I use, Aqua
> > means cool tone which is Cb/Cr manipulations.
> > 
> > On 09/19/2011 04:38 AM, Laurent Pinchart wrote:
> >> On Friday 16 September 2011 19:05:28 Sylwester Nawrocki wrote:
> >>> Add V4L2_COLORFX_AQUA image effect in the V4L2_CID_COLORFX menu.
> >> 
> >> What's the aqua effect ?
> 
> Aqua means cool tone, as Subash explained. It's somehow opposite to Sepia
> which is warm tone. I'll improve the commit description in the next patch
> version.
> I tried to make a table with short description of each color effect in the
> DocBook but it was taking me too long so I dropped it for a moment.
> 
> I have attached an image presenting the color effects. Maybe it's worth
> to add something like this to the DocBook, or perhaps just the
> descriptions.

Thanks for the information. I think it would indeed be useful to add 
descriptions to the documentation.

> >>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> >>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >>> ---
> >>> 
> >>>   Documentation/DocBook/media/v4l/controls.xml |    5 +++--
> >>>   include/linux/videodev2.h                    |    1 +
> >>>   2 files changed, 4 insertions(+), 2 deletions(-)
> >>> 
> >>> diff --git a/Documentation/DocBook/media/v4l/controls.xml
> >>> b/Documentation/DocBook/media/v4l/controls.xml index 8516401..f3c6457
> >>> 100644
> >>> --- a/Documentation/DocBook/media/v4l/controls.xml
> >>> +++ b/Documentation/DocBook/media/v4l/controls.xml
> >>> @@ -294,8 +294,9 @@ minimum value disables backlight
> >>> compensation.</entry>
> >>> 
> >>>   <constant>V4L2_COLORFX_SKETCH</constant>  (5),
> >>>   <constant>V4L2_COLORFX_SKY_BLUE</constant>  (6),
> >>>   <constant>V4L2_COLORFX_GRASS_GREEN</constant>  (7),
> >>> 
> >>> -<constant>V4L2_COLORFX_SKIN_WHITEN</constant>  (8) and
> >>> -<constant>V4L2_COLORFX_VIVID</constant>  (9).</entry>
> >>> +<constant>V4L2_COLORFX_SKIN_WHITEN</constant>  (8),
> >>> +<constant>V4L2_COLORFX_VIVID</constant>  (9) and
> >>> +<constant>V4L2_COLORFX_AQUA</constant>  (10).</entry>
> >>> 
> >>>       </row>
> >>>       <row>
> >>>       <entry><constant>V4L2_CID_ROTATE</constant></entry>
> >>> 
> >>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> >>> index fca24cc..5032226 100644
> >>> --- a/include/linux/videodev2.h
> >>> +++ b/include/linux/videodev2.h
> >>> @@ -1144,6 +1144,7 @@ enum v4l2_colorfx {
> >>> 
> >>>       V4L2_COLORFX_GRASS_GREEN = 7,
> >>>       V4L2_COLORFX_SKIN_WHITEN = 8,
> >>>       V4L2_COLORFX_VIVID = 9,
> >>> 
> >>> +    V4L2_COLORFX_AQUA = 10,
> >>> 
> >>>   };
> >>>   #define V4L2_CID_AUTOBRIGHTNESS            (V4L2_CID_BASE+32)
> >>>   #define V4L2_CID_BAND_STOP_FILTER        (V4L2_CID_BASE+33)

-- 
Regards,

Laurent Pinchart
