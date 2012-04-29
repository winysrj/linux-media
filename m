Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60014 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102Ab2D2X2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 19:28:44 -0400
Subject: Re: [GIT PULL FOR v3.5] An ivtv fix and support suspend/resume in
 radio-keene
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Sun, 29 Apr 2012 19:28:39 -0400
In-Reply-To: <201204271356.37069.hverkuil@xs4all.nl>
References: <201204271356.37069.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335742122.25802.8.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-04-27 at 13:56 +0200, Hans Verkuil wrote:
> Hi Mauro,
> 
> One small trivial ivtv fix and a patch that adds support for suspend/resume
> to the radio-keene driver.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:
> 
>   [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)
> 
> are available in the git repository at:
> 
>   git://linuxtv.org/hverkuil/media_tree.git fixes
> 
> for you to fetch changes up to 71ea18d3e92d834926751f8460cf6893424b3852:
> 
>   radio-keene: support suspend/resume. (2012-04-27 09:57:02 +0200)
> 
> ----------------------------------------------------------------
> Hans Verkuil (2):
>       ivtv: set max/step to 0 for PTS and FRAME controls.
>       radio-keene: support suspend/resume.

The ivtv change looks OK to me.  Even though v4l2_ctrl_fill() fixes up
those errors anyway.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy 

> 
>  drivers/media/radio/radio-keene.c      |   20 ++++++++++++++++++++
>  drivers/media/video/ivtv/ivtv-driver.c |    4 ++--
>  2 files changed, 22 insertions(+), 2 deletions(-)


