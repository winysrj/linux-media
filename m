Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2APWQg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 17:16:36 -0500
Date: Mon, 16 Jan 2012 23:16:31 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
cc: linuxtv-commits@linuxtv.org,
	Rupert Eibauer <Rupert.Eibauer@ces.ch>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT
 documentation
In-Reply-To: <E1Rmmdy-0002zt-5K@www.linuxtv.org>
Message-ID: <Pine.LNX.4.64.1201162315200.15379@axis700.grange>
References: <E1Rmmdy-0002zt-5K@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Jan 2012, Mauro Carvalho Chehab wrote:

> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] V4L2 Spec: improve the G/S_INPUT/OUTPUT documentation
> Author:  Hans Verkuil <hans.verkuil@cisco.com>
> Date:    Wed Jan 11 07:37:54 2012 -0300

[snip]

> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-output.xml b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> index fd45f1c..4533068 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-output.xml
> @@ -61,8 +61,9 @@ desired output in an integer and call the
>  <constant>VIDIOC_S_OUTPUT</constant> ioctl with a pointer to this integer.
>  Side effects are possible. For example outputs may support different
>  video standards, so the driver may implicitly switch the current
> -standard. It is good practice to select an output before querying or
> -negotiating any other parameters.</para>
> +standard.
> +standard. Because of these possible side effects applications
> +must select an output before querying or negotiating any other parameters.</para>

something seems to be wrong here.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
