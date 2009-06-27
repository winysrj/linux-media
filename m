Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1956 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbZF0MJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 08:09:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 2/3 - v0] V4L: ccdc driver - adding support for camera capture
Date: Sat, 27 Jun 2009 14:09:32 +0200
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
References: <1246053910-8337-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1246053910-8337-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906271409.32459.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 27 June 2009 00:05:10 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> Following updates to ccdc driver :-
>  	1) Adding support for camera capture using mt9t031
> 	2) Changed default resolution for ycbcr capture to NTSC to match
> 	   with tvp514x driver.
> 	3) Returns proper error code from ccdc_init (comments against previous patch
> 	   version v3)
> 
> Mandatory Reviewers: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
> 
>  drivers/media/video/davinci/dm355_ccdc.c  |   21 +++++++++++++--------
>  drivers/media/video/davinci/dm644x_ccdc.c |   13 +++++++++----
>  include/media/davinci/dm355_ccdc.h        |    2 +-
>  include/media/davinci/dm644x_ccdc.h       |    2 +-
>  4 files changed, 24 insertions(+), 14 deletions(-)
> 

<snip>

Looks OK.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
