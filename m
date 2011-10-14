Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:56625 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933349Ab1JNRTm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 13:19:42 -0400
Date: Fri, 14 Oct 2011 20:19:38 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/4] v4l: add support for selection api
Message-ID: <20111014171938.GG10001@valkosipuli.localdomain>
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
 <1314793703-32345-2-git-send-email-t.stanislaws@samsung.com>
 <20111012114828.GE10001@valkosipuli.localdomain>
 <4E95AD64.2020702@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E95AD64.2020702@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 12, 2011 at 05:08:20PM +0200, Tomasz Stanislawski wrote:
> On 10/12/2011 01:48 PM, Sakari Ailus wrote:
> >Hi Tomasz,
> >
> >On Wed, Aug 31, 2011 at 02:28:20PM +0200, Tomasz Stanislawski wrote:
> >...
> >>diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> >>index fca24cc..b7471fe 100644
> >>--- a/include/linux/videodev2.h
> >>+++ b/include/linux/videodev2.h
> >>@@ -738,6 +738,48 @@ struct v4l2_crop {
> >>  	struct v4l2_rect        c;
> >>  };
> >>
> >>+/* Hints for adjustments of selection rectangle */
> >>+#define V4L2_SEL_SIZE_GE	0x00000001
> >>+#define V4L2_SEL_SIZE_LE	0x00000002
> >
> >A minor comment. If the patches have not been pulled yet, how about adding
> >FLAG_ to the flag names? I.e. V4L2_SEL_FLAG_SIZE_GE and
> >V4L2_SEL_FLAG_SIZE_LE.
> 
> Hi Sakari,
> 
> The idea is good. I preferred to avoid using long names if possible.
> I agree that using _FLAGS_ produce more informative name.
> I'll fix it in the new version of selection API.

Hi Tomasz,

I'd also have the same comment on the selection targets.
V4L2_SEL_TGT_CROP_ACTIVE, for example?

What do you think?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
