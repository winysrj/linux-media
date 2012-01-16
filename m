Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:31955 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab2APP1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 10:27:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC PATCH] Fixup control names to use consistent capitalization
Date: Mon, 16 Jan 2012 16:26:58 +0100
Cc: "'linux-media'" <linux-media@vger.kernel.org>,
	"'Sakari Ailus'" <sakari.ailus@iki.fi>
References: <201201161435.43652.hverkuil@xs4all.nl> <000201ccd458$6b3d6ce0$41b846a0$%debski@samsung.com>
In-Reply-To: <000201ccd458$6b3d6ce0$41b846a0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161626.58976.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 16 January 2012 15:09:06 Kamil Debski wrote:
> Hi Hans,
> 
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: 16 January 2012 14:36
> > 
> > Hi all,
> > 
> > This patch fixes several control names with inconsistent capitalization
> > and other inconsistencies (and a spelling mistake in one name as well).
> > 
> > Kamil, Sakari, please take a look as most of the affected strings are
> > either MPEG or Flash controls.
> 
> Thank you for your patch.
> I've had a look at the codec controls and all seems fine.
> 
> > Note that I saw a few strings as well that are longer then 31 characters.
> > Those will be cut off when returns in queryctrl. I'm not sure yet what to
> > do about those.
> 
> I think it's sensible to abbreviate them. You can find one suggestion
> below.

...

> > +	case V4L2_CID_MPEG_VIDEO_MAX_REF_PIC:			return "Max
> > Number of Reference Pictures";
> 
> This could be "Max Number of Reference Pics" or "Max Number of Ref Pictures".

I'm going with the first one.

I'll also change "Minimum Number of Capture Buffers" to "Min Number of Capture Buffers".
Ditto for Output Buffers.

Regards,

	Hans
