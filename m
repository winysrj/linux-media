Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41010 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1JQQyd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Oct 2011 12:54:33 -0400
Date: Mon, 17 Oct 2011 19:54:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/4] v4l: add support for selection api
Message-ID: <20111017165429.GJ10001@valkosipuli.localdomain>
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
 <1314793703-32345-2-git-send-email-t.stanislaws@samsung.com>
 <20111012114828.GE10001@valkosipuli.localdomain>
 <4E95AD64.2020702@samsung.com>
 <20111014171938.GG10001@valkosipuli.localdomain>
 <4E9C2E25.2080803@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9C2E25.2080803@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 17, 2011 at 03:31:17PM +0200, Tomasz Stanislawski wrote:
> Hi Sakari,
> 
> On 10/14/2011 07:19 PM, Sakari Ailus wrote:
> >On Wed, Oct 12, 2011 at 05:08:20PM +0200, Tomasz Stanislawski wrote:
> >>On 10/12/2011 01:48 PM, Sakari Ailus wrote:
> >>>Hi Tomasz,
> >>>
> >>>On Wed, Aug 31, 2011 at 02:28:20PM +0200, Tomasz Stanislawski wrote:
> >>>...
> >>>>diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> >>>>index fca24cc..b7471fe 100644
> >>>>--- a/include/linux/videodev2.h
> >>>>+++ b/include/linux/videodev2.h
> >>>>@@ -738,6 +738,48 @@ struct v4l2_crop {
> >>>>  	struct v4l2_rect        c;
> >>>>  };
> >>>>
> >>>>+/* Hints for adjustments of selection rectangle */
> >>>>+#define V4L2_SEL_SIZE_GE	0x00000001
> >>>>+#define V4L2_SEL_SIZE_LE	0x00000002
> >>>
> >>>A minor comment. If the patches have not been pulled yet, how about adding
> >>>FLAG_ to the flag names? I.e. V4L2_SEL_FLAG_SIZE_GE and
> >>>V4L2_SEL_FLAG_SIZE_LE.
> 
> I thought that it may be worth to drop _SEL_. The constraint flags
> could be reused in future ioctls? I mean S_FRAMESIZES or extensions
> to control API. What do you think?
> 
> >>
> >>Hi Sakari,
> >>
> >>The idea is good. I preferred to avoid using long names if possible.
> >>I agree that using _FLAGS_ produce more informative name.
> >>I'll fix it in the new version of selection API.
> >
> >Hi Tomasz,
> >
> >I'd also have the same comment on the selection targets.
> >V4L2_SEL_TGT_CROP_ACTIVE, for example?
> 
> It is logical to use _TGT_, it is sad that the names becomes so long :/

It's not _that_ long --- we have longer ones e.g. in include/linux/media.h.
They only need to be just descriptive enough...

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
