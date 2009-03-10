Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:1957 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbZCJHbo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2009 03:31:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: get rid of video_decoder.h
Date: Tue, 10 Mar 2009 08:31:32 +0100
References: <E1LgqdW-00019H-Vp@www.linuxtv.org>
In-Reply-To: <E1LgqdW-00019H-Vp@www.linuxtv.org>
Cc: Mauro Carvalho Chehab via Mercurial <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903100831.32788.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 10 March 2009 02:20:02 Patch from Mauro Carvalho Chehab wrote:
> The patch number 10870 was added via Mauro Carvalho Chehab
> <mchehab@redhat.com> to http://linuxtv.org/hg/v4l-dvb master development
> tree.
>
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
>
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
>
> ------
>
> From: Mauro Carvalho Chehab  <mchehab@redhat.com>
> v4l2-ioctl: get rid of video_decoder.h
>
>
> The V4L1 obsoleted header video_decoder.h is not used anymore by any
> driver. Only a name decoding function at v4l2-ioctl still implements it.

Hoorah! Note that video_encoder.h is now also unused, but since that header 
isn't in v4l-dvb it should be removed manually in the kernel during the 
2.6.30 merge window.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
