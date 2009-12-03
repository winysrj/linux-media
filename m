Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:46834 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbZLCS4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Dec 2009 13:56:15 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-media@vger.kernel.org
Subject: V4L1 compatibility broken for VIDIOCGTUNER with radio
Date: Thu, 3 Dec 2009 16:56:20 -0200
MIME-Version: 1.0
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031656.20893.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

After commit 9bedc7f ("V4L/DVB (12429): v4l2-ioctl: fix G_STD and G_PARM 
default handlers"), radio software using V4L1 stopped to work on a saa7134 
card, a git bisect pointed to this commit introducing the regression. All 
VIDIOCGTUNER calls on a v4l1 application are returning -EINVAL after this 
commit.

Investigating the issue, it turns out that v4l1_compat_get_tuner calls 
VIDIOC_G_STD ioctl, but as it is a radio device (saa7134-radio) it now is 
returning -EINVAL to user space applications which are being confused about 
this.

May be VIDIOC_G_STD change in the commit above should be reverted, or 
v4l1_compat_get_tuner changed to not return error with G_STD, or not call 
G_STD ioctl for a radio device?

--
[]'s
Herton
