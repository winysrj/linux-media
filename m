Return-path: <mchehab@gaivota>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2476 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0LaPIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 10:08:39 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: nasty bug at qv4l2
Date: Fri, 31 Dec 2010 16:08:25 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D11E170.6050500@redhat.com> <201012241520.01460.hverkuil@xs4all.nl> <4D1DF072.7080408@redhat.com>
In-Reply-To: <4D1DF072.7080408@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311608.25285.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday, December 31, 2010 16:02:10 Hans de Goede wrote:
> Hi,
> 
> Hans V. I've tested your patch for avoiding the double
> conversion problem, and I can report it fixes the issue seen with
> webcameras which need 90 degrees rotation.
> 
> While testing I found a bug in gspca, which gets triggered by
> qv4l2 which makes it impossible to switch between userptr and
> mmap mode. While fixing that I also found some locking issues in
> gspca. As these all touch the gscpa core I'll send a patch set
> to Jean Francois Moine for this.
> 
> With the issues in gspca fixed, I found a bug in qv4l2 when using
> read mode in raw mode (not passing the correct src_size to
> libv4lconvert_convert).
> 
> I've attached 2 patches to qv4l2, fixing the read issue and a similar
> issue in mmap / userptr mode. These apply on top of your patch.

Thanks for testing this! I've committed mine and your patches for qv4l2.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
