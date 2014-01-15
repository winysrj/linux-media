Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f67.google.com ([209.85.215.67]:43590 "EHLO
	mail-la0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaAOG2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 01:28:43 -0500
Received: by mail-la0-f67.google.com with SMTP id eh20so255952lab.6
        for <linux-media@vger.kernel.org>; Tue, 14 Jan 2014 22:28:41 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 14:28:41 +0800
Message-ID: <CACDDY7429te6a7cUQ0Z=sX6TELjn48FQHiuW=YtBsyOkzrCqZA@mail.gmail.com>
Subject: how can I get compat_ioctl support for v4l2_subdev_fops
From: Jianle Wang <victure86@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all, :
I use the media-ctl from http://git.ideasonboard.org/media-ctl.git
It is compiled into a 32 bit application. Run on a 64 bit CPU. The
version of kernel is 3.10.

When call ioctl(, VIDIOC_SUBDEV_S_SELECTION,), meet the below warning:
[   97.186338] c0 707 (drv_test) compat_ioctl32: unknown ioctl 'V',
dir=3, #62 (0xc040563e)
[   97.203252] c0 707 (drv_test) WARNING: no compat_ioctl for v4l-subdev1

VIDIOC_SUBDEV_S_SELECTION is not supported for compat_iocl. And I list
others subdev’s ioctl, which are also not included

in v4l2_compat_iocl32().
How can I get these compat_ioctl?
Have they been added in v4l2_compat_iocl32() or We have added a
compat_ioctl32 in v4l2_subdev_fops?

VIDIOC_SUBDEV_G_FMT
VIDIOC_SUBDEV_S_FMT
VIDIOC_SUBDEV_G_CROP
VIDIOC_SUBDEV_S_CROP
VIDIOC_SUBDEV_ENUM_MBUS_CODE
VIDIOC_SUBDEV_ENUM_FRAME_SIZE
VIDIOC_SUBDEV_G_FRAME_INTERVAL
VIDIOC_SUBDEV_S_FRAME_INTERVAL
VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL
VIDIOC_SUBDEV_G_SELECTION
VIDIOC_SUBDEV_S_SELECTION
default
v4l2_subdev_call(sd, core, ioctl, cmd, arg);
