Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:39592 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896AbbFHMMF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Jun 2015 08:12:05 -0400
Message-ID: <5575868D.5010908@xs4all.nl>
Date: Mon, 08 Jun 2015 14:11:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4]  Support for interlaced in cvt/gtf timings
References: <1432272457-709-1-git-send-email-prladdha@cisco.com>
In-Reply-To: <1432272457-709-1-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prashant,

I've merged patches 1 and 2, but I'm postponing 3 and 4: I'd like to be able to
test this before merging, ideally with the cobalt driver, but that will take time.

They are in my todo list, so they won't be forgotten. In the meantime it is useful
to have support for this in v4l2-dv-timings should someone want to use it.

Regards,

	Hans

On 05/22/2015 07:27 AM, Prashant Laddha wrote:
> Please find version 2 of patches adding interlaced support in cvt/gtf
> timing.
> 
> Changes compared to v1:
> Incorporated the comments from review of first RFC. It was about the 
> error calculation of vertical back porch due to rounding. (Thanks to
> Hans for spoting this error).
> 
> Prashant Laddha (4):
>   v4l2-dv-timings: add interlace support in detect cvt/gtf
>   vivid: Use interlaced info for cvt/gtf timing detection
>   adv7604: Use interlaced info for cvt/gtf timing detection
>   adv7842: Use interlaced info for cvt/gtf timing detection
> 
>  drivers/media/i2c/adv7604.c                  |  4 +--
>  drivers/media/i2c/adv7842.c                  |  4 +--
>  drivers/media/platform/vivid/vivid-vid-cap.c |  5 +--
>  drivers/media/v4l2-core/v4l2-dv-timings.c    | 53 ++++++++++++++++++++++++----
>  include/media/v4l2-dv-timings.h              |  6 ++--
>  5 files changed, 58 insertions(+), 14 deletions(-)
> 

