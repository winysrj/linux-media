Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:9087 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2IMKrw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:47:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 API PATCH 10/28] Rename V4L2_(IN|OUT)_CAP_CUSTOM_TIMINGS.
Date: Thu, 13 Sep 2012 12:47:47 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <0c01d1164be688b20ae03f51c700a31a7f154acc.1347023744.git.hans.verkuil@cisco.com> <1460675.kl1J5jUHQS@avalon>
In-Reply-To: <1460675.kl1J5jUHQS@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209131247.47754.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 13 September 2012 04:22:52 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch.
> 
> On Friday 07 September 2012 15:29:10 Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > The 'custom' timings are no longer just for custom timings, but also for
> > standard CEA/VESA timings. So rename to V4L2_IN/OUT_CAP_DV_TIMINGS.
> > 
> > The old define is still kept for backwards compatibility.
> 
> Should they be added to feature-removal-schedule.txt ?

That might be a good idea. The old defines are basically only used on embedded
systems, so we can probably remove them by 3.9 or so.

Regards,

	Hans
