Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3229 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761175AbZFJUJW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 16:09:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc-camera: status, roadmap
Date: Wed, 10 Jun 2009 22:09:07 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.0906101802450.4817@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0906101802450.4817@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906102209.08535.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Let me start with a big Thank You! for all your hard work on this! Much 
appreciated!

On Wednesday 10 June 2009 18:45:36 Guennadi Liakhovetski wrote:
> Hi all
>
> for those interested here's a (not so) short status report and a proposed
> roadmap for general soc-camera development, and, of course, its ongoing
> conversion to v4l2-subdev API.
>
> 1. v4l2-subdev conversion. I have posted several versions of the
> conversion patch series to the list, of which the last takes an IMHO
> correct approach of a graduate conversion, avoiding mega-patches,
> modifying multiple platforms and drivers at once. With this approach the
> roadmap consists of the following steps:
>
> 1.1. preparatory patch to soc-camera core, allowing parallel existence of
> "legacy" (all in the mainline) platforms and converted platforms (pcm037
> i.MX31 platform so far) by introducing some backwards compatibility code.
> This patch is currently in v4l next and in linux-next, i.e., it is going
> in with 2.6.31.
>
> 1.2. convert all (around 7) mainline platforms to the new layout. This
> step is necessary for further conversions, but it depends on 1.1.
> Therefore this can only be done later in 2.6.31 merge window, when 1.1.
> is in the mainline.
>
> 1.3. convert soc-camera core and drivers to an intermediate state, with
> which all cameras are registered by platforms as platform devices, later
> soc-camera core probes them and dynamically registers respective i2c (or
> other, as in soc_camera_platform.c case) devices. This patch depends on
> 1.2., and it is hard to expect to be able to push these three steps
> within the 2.6.31 merge window. It could be possible, we could request to
> accept this patch after -rc1, maybe we would be allowed to do this, but
>
> 1.4. this is the actual conversion to v4l2-subdev. It depends on some
> bits and pieces in the v4l2-subdev framework, which are still in progress
> (e.g. v4l2_i2c_new_subdev_board), I believe (Hans, am I right? or what's
> the outcome of Mauro's last reply to you in the "[PULL]
> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-subdev" thread?), so, it
> becomes practically impossible to also pull it for 2.6.31.

I haven't seen a reaction yet from Mauro regarding my latest pull request: I 
think it addresses all his concerns regarding existing functionality so I 
actually hope this can be merged. It would help a lot with this and similar 
efforts.

> Now, I do not want to have soc-camera in the intermediate 1.3. state for
> a whole 2.6.31 kernel, which means, we have to postpone 1.3. and 1.4.
> until 2.6.32.
>
> 2. The above means, I'll have to maintain and update my patches for a
> whole 2.6.31 development cycle. In this time I'll try to update and
> upload them as a quilt patch series and announce it on the list a couple
> of times.
>
> 3. This also means, development will become more difficult, new features
> and drivers will only be accepted on the top of my patch stack, bugfixes
> will have to be accpeted against the mainline, which then will mean extra
> porting work for me.

If there is anything I can do to help this along, please let me know. In 
particular: what else besides the v4l2_i2c_new_subdev_board do you need? I 
didn't have much time in the past few weeks, but things are more relaxed 
now and I expect to be able to do a lot more in the coming weeks (fingers 
crossed :-) ).

Regards,

	Hans

> 4. In a message I posted a few minutes ago
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg06294.html
>
> I'm asking about a correct interpretation of S_CROP and S_FMT operations.
> I suspect, what soc-camera framework and all drivers thereunder are doing
> is wrong, and have to be fixed rather sooner than later. However, I'd be
> very much against fixing this in the present stack, because that would
> mean a _lot_ of porting. So, this will remain standard-non-compliant
> until 2.6.32 too.
>
> 5. The conversion described in (1) is only partial, in its current form
> it does not replace the existing soc-camera API between sensor drivers
> and the soc-camera core with v4l2-subdev operations completely. Partly
> because many of the current soc-camera methods are still missing in
> v4l2-subdev, partly because it just makes more sense to first push the
> principle conversion in the mainline, which at least removes soc-camera
> device registration and switches to i2c driver autoloading and replaces
> some trivially replaceable methods, like [gs]_fmt, [gs]_register,
> [gs]_control. Some of the missing methods, like [gs]_crop should be easy
> to add, others, like pixel format and bus parameter negotiations would
> require some thinking and substantial work. Which makes this all some
> 2.6.33
> material... but who wants to think that far...
>
> 6. As you see, this all looks like a lot of work, and I so far have been
> doing all of this in my free time. But it would become difficult with
> these amounts of work. So, I would welcome if either someone would step
> forward to help with this work, or if some company would volunteer to
> support this work financially.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
