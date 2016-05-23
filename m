Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:49150 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753776AbcEWLpM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 07:45:12 -0400
Subject: Re: drivers/media/v4l2-core/v4l2-ioctl.c:2174: duplicate expression ?
To: David Binderman <linuxdev.baldrick@gmail.com>,
	mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	dcb314@hotmail.com
References: <CAMzoamZ+bnvJ=yUOW9V3QqBRQ1+ucsUKiVZENS8euXf3jHOG3g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5742ED42.5090407@xs4all.nl>
Date: Mon, 23 May 2016 13:45:06 +0200
MIME-Version: 1.0
In-Reply-To: <CAMzoamZ+bnvJ=yUOW9V3QqBRQ1+ucsUKiVZENS8euXf3jHOG3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/23/2016 01:35 PM, David Binderman wrote:
> Hello there,
> 
> linux-next/drivers/media/v4l2-core/v4l2-ioctl.c:2174] ->
> [linux-next/drivers/media/v4l2-core/v4l2-ioctl.c:2174]: (style) Same
> expression on both sides of '&&'.
> 
> Source code is
> 
>     if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))
> 
> Suggest either remove the duplication or test some other field.

Yeah, it should have tested for vidioc_g_selection. Thanks for reporting
this really dumb mistake!

Will post a patch for this in a minute.

Regards,

	Hans
