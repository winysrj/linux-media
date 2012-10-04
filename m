Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3769 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab2JDGpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 02:45:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC PATCH 1/3] s5p-g2d: fix compiler warning
Date: Thu, 4 Oct 2012 08:43:55 +0200
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	Anatolij Gustschin <agust@denx.de>
References: <1349168240-29269-1-git-send-email-hans.verkuil@cisco.com> <760bdb23b40b9ce3a8044a3379510889db4bfcf7.1349168132.git.hans.verkuil@cisco.com> <506C1090.9040008@samsung.com>
In-Reply-To: <506C1090.9040008@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210040843.55489.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed October 3 2012 12:16:48 Sylwester Nawrocki wrote:
> On 10/02/2012 10:57 AM, Hans Verkuil wrote:
> > drivers/media/platform/s5p-g2d/g2d.c:535:2: warning: passing argument 3 of 'vidioc_try_crop' discards 'const' qualifier from pointer target type [enabled by default]
> > drivers/media/platform/s5p-g2d/g2d.c:510:12: note: expected 'struct v4l2_crop *' but argument is of type 'const struct v4l2_crop *'
> > 
> > This is fall-out from this commit:
> > 
> > commit 4f996594ceaf6c3f9bc42b40c40b0f7f87b79c86
> > Author: Hans Verkuil <hans.verkuil@cisco.com>
> > Date:   Wed Sep 5 05:10:48 2012 -0300
> > 
> >     [media] v4l2: make vidioc_s_crop const
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Aplied, thanks.

Just to be clear, you're taking care of these s5p patches through your tree, right?

Regards,

	Hans
