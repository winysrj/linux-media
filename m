Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33051 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972AbaKOOIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Nov 2014 09:08:13 -0500
Message-ID: <54675E45.8020603@xs4all.nl>
Date: Sat, 15 Nov 2014 15:08:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
	Andrey Utkin <andrey.krieger.utkin@gmail.com>
CC: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
	"hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas
 or help?
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>	<m3sihmf3mc.fsf@t19.piap.pl>	<CANZNk81y8=ugk3Ds0FhoeYBzh7ATy1Uyo8gxUQFoiPcYcwD+yQ@mail.gmail.com> <CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
In-Reply-To: <CAM_ZknUoNBfnKJW-76FE1tW29O6oFAw+KDYPsViTLw7u-vFXuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrey,

On 11/15/2014 02:48 PM, Andrey Utkin wrote:
> Thanks to all for the great help so far, but I've got another issue
> with upstream driver.
> 
> In upstream there's no more module parameter for video standard
> (NTSC/PAL). But there's VIDIOC_S_STD handling procedure. But it turns
> out not to work correctly: the frame is offset, so that in the bottom
> there's black horizontal bar.
> The S_STD ioctl call actually makes difference, because without that
> the frame "slides" vertically all the time. But after the call the
> picture is not correct.

That's strange. I know I tested it at the time. I assume it is the PAL
standard that isn't working (as opposed to NTSC)? Or does it just always
fail when you switch between the two standards?

> 
> Such change didn't help:
> https://github.com/krieger-od/linux/commit/55b796c010b622430cb85f5b8d7d14fef6f04fb4
> So, temporarily, I've hardcoded this for exact customer who uses PAL:
> https://github.com/krieger-od/linux/commit/2c26302dfa6d7aa74cf17a89793daecbb89ae93a
> rmmod/modprobe cycle works fine and doesn't make any difference from
> reboot, but still it works correctly only with PAL hardcoded for the
> first-time initialization.
> 
> Any ideas why wouldn't it work to change the mode after the driver load?

Not really. I will have to test this next week (either Monday or Friday) with
my solo board.

> Would it be allowed to add back that kernel module parameter (the one
> passed at module load time)?

No. That's a hack, the S_STD call should just work and we need to figure out
why it fails.

Regards,

	Hans
