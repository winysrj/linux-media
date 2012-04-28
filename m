Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4238 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2D1LNH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 07:13:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR v3.5] An ivtv fix and support suspend/resume in radio-keene
Date: Sat, 28 Apr 2012 13:12:48 +0200
Cc: Andy Walls <awalls@md.metrocast.net>,
	Ondrej Zary <linux@rainbow-software.org>
References: <201204271356.37069.hverkuil@xs4all.nl>
In-Reply-To: <201204271356.37069.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204281312.48543.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

One other fix was added:

      radio-isa: fix memory leak

 drivers/media/radio/radio-isa.c        |    8 +++-----

v4l2_ctrl_handler_free wasn't called if there was a problem creating controls.

Regards,

	Hans

On Friday, April 27, 2012 13:56:37 Hans Verkuil wrote:
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
> 
>  drivers/media/radio/radio-keene.c      |   20 ++++++++++++++++++++
>  drivers/media/video/ivtv/ivtv-driver.c |    4 ++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
