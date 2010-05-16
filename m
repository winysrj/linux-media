Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4978 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0EPIYf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 04:24:35 -0400
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id o4G8OR9G014243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 16 May 2010 10:24:34 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: RFC: behavior of QUERYSTD when no signal is present
Date: Sun, 16 May 2010 10:26:04 +0200
References: <201005091123.05375.hverkuil@xs4all.nl>
In-Reply-To: <201005091123.05375.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005161026.05004.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 09 May 2010 11:23:05 Hans Verkuil wrote:
> What is VIDIOC_QUERYSTD supposed to do when there is no signal?
> 
> The spec says this:
> 
> "The hardware may be able to detect the current video standard automatically.
> To do so, applications call VIDIOC_QUERYSTD with a pointer to a v4l2_std_id
> type. The driver stores here a set of candidates, this can be a single flag
> or a set of supported standards if for example the hardware can only
> distinguish between 50 and 60 Hz systems. When detection is not possible or
> fails, the set must contain all standards supported by the current video
> input or output."
> 
> The last sentence is the problem. There are several possibilities:
> 
> 1) The hardware is physically unable to detect the current video std. In that
> case this ioctl shouldn't be implemented at all.
> 
> 2) While detecting the std an error occurs (e.g. i2c read error). In that case
> the error should be returned.
> 
> 3) There is no input signal. Does that constitute 'detection is not possible or
> fails'? If so, then all supported standards should be returned. But that seems
> very strange. After all, I did detect the standard: i.e. there is none, so I
> would say that QUERYSTD should return V4L2_STD_UNKNOWN (0).
> 
> A quick check of the current state of affairs when no signal is present reveals
> that:
> 
> - saa7115, ks0127, saa7191 return 0 with std set to V4L2_STD_ALL
> - adv7180, vpx3220 return 0 with std set to V4L2_STD_UNKNOWN
> - saa7110 returns 0 with std set to the current std
> - bt819 and bttv do not handle this case at all, and just pick 50 Hz or 60 Hz
> - tvp514x returns -EINVAL.
> 
> Lovely... :-)
> 
> It is clear that applications currently have no hope in hell to use the output
> of querystd in a reliable manner. For all practical purposes the behavior of
> querystd when no signal is present is undefined.
> 
> I would propose to specify that if no signal is present then QUERYSTD should
> return 0 with std V4L2_STD_UNKNOWN.

I received no comments, so I will prepare patches to implement this proposal.

Regards,

	Hans

> It would also be consistent with QUERY_DV_PRESET where the preset DV_INVALID
> is returned in that case.
> 
> If we decide to change it, then it is trivial to fix all drivers that implement
> querystd.
> 
> Comments?
> 
> 	Hans
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
