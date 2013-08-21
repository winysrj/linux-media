Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:50242 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab3HUIiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:38:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] s5p-tv: Include missing v4l2-dv-timings.h header file
Date: Wed, 21 Aug 2013 10:38:18 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1376856050-30538-1-git-send-email-s.nawrocki@samsung.com> <5211C608.60201@xs4all.nl> <5214796E.5050000@samsung.com>
In-Reply-To: <5214796E.5050000@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201308211038.18389.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 21 August 2013 10:25:18 Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 08/19/2013 09:15 AM, Hans Verkuil wrote:
> > On 08/18/2013 10:00 PM, Sylwester Nawrocki wrote:
> >> Include the v4l2-dv-timings.h header file which in the s5p-tv driver which
> >> was supposed to be updated in commit 2576415846bcbad3c0a6885fc44f95083710
> >> "[media] v4l2: move dv-timings related code to v4l2-dv-timings.c"
> >>
> >> This fixes following build error:
> >>
> >> drivers/media/platform/s5p-tv/hdmi_drv.c: In function ‘hdmi_s_dv_timings’:
> >> drivers/media/platform/s5p-tv/hdmi_drv.c:628:3: error: implicit declaration of function ‘v4l_match_dv_timings’
> >>
> >> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > My apologies for missing this one.
> 
> That's all right. Shit happens. I was wondering why this error
> didn't show up in your daily builds.

I had a local patch for that and I forgot to remove it. So next time it will
show up as an error again.

Regards,

	Hans
