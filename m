Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44970 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1GDWrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 18:47:15 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] DV timings spec fixes at V4L2 API - was: [PATCH 1/8] v4l: add macro for 1080p59_54 preset
Date: Tue, 5 Jul 2011 00:47:43 +0200
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com> <1309351877-32444-2-git-send-email-t.stanislaws@samsung.com> <4E11E5AE.30304@redhat.com>
In-Reply-To: <4E11E5AE.30304@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107050047.44275.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Monday 04 July 2011 18:09:18 Mauro Carvalho Chehab wrote:

[snip]

> 1) PRESET STANDARDS
>    ====== =========
> 
> There are 3 specs involved with DV presets: ITU-R BT 709 and BT 1120 and
> CEA 861.
> 
> At ITU-R BT.709, both 60Hz and 60/1.001 Hz are equally called as "60 Hz".
> BT.1120 follows the same logic, as it uses BT.709 as a reference for video
> timings.
> 
> The CEA-861-E spec says at item 4, that:

[snip]

> At the same item, the table 2 describes several video parameters for each
> preset, associating the Video Identification Codes (VIC) for each preset.

This might be a bit out of scope, but why aren't we using the VICs as DV 
presets ?

-- 
Regards,

Laurent Pinchart
