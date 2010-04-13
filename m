Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4594 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab0DMNmU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Apr 2010 09:42:20 -0400
Message-ID: <258a57e817688f9fa0c1e87fdadc740c.squirrel@webmail.xs4all.nl>
In-Reply-To: <33AB447FBD802F4E932063B962385B351D84C129@shsmsx501.ccr.corp.intel.com>
References: <33AB447FBD802F4E932063B962385B351D84C129@shsmsx501.ccr.corp.intel.com>
Date: Tue, 13 Apr 2010 15:42:17 +0200
Subject: Re: [RFC] support more color effects by extending the
 V4L2_CID_COLORFX user contorl ID
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Bian, Jonathan" <jonathan.bian@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi linux-media,
>
> Current V4l2 support a limited image effects (black white and sepia) and
> this is a RFC to support more color effects by extending the
> V4L2_CID_COLORFX user control ID, these effects are not platform specific
> and are available in mainstream digital camera devices, and will be
> supported by the ISP on Intel Atom platforms.
>
> The image effects are listed as in below, we are proposing to extend
> V4L2_CID_COLORFX to support them:
>
> V4L2_COLORFX_NEGATIVE - negative image effect.
> V4L2_COLORFX_EMBOSS - emboss image effect
> V4L2_COLORFX_SKETECH - sketch image effect
> V4L2_COLORFX_SKY_BLUE - sky blue image effect
> V4L2_COLORFX_GRASS_GREEN - grass green image effect
> V4L2_COLORFX_SKIN_WHITEN - skin whiten image effect
> V4L2_COLORFX_VIVID - vivid image effect
>
> The v4l2_colorfx also needs to contain more enum items (as in below) to
> support them, welcome any comment and suggest.
>
> enum v4l2_colorfx {
> 	V4L2_COLORFX_DEFAULT	= 0,
> 	V4L2_COLORFX_BW		= 1,
> 	V4L2_COLORFX_SEPIA	= 2,
> 	V4L2_COLORFX_NEGATIVE = 3,
> 	V4L2_COLORFX_EMBOSS =4,
> 	V4L2_COLORFX_SKETECH =5,

Typo: SKETECH -> SKETCH

> 	V4L2_COLORFX_SKY_BLUE =6,
> 	V4L2_COLORFX_GRASS_GREEN =7,
> 	V4L2_COLORFX_SKIN_WHITEN = 8,
> 	V4L2_COLORFX_VIVID = 9,
> };

Looks fine to me! Remember to also change v4l2_ctrl_get_menu() in
v4l2-common.c.

Regards,

        Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

