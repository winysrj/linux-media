Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:38227 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756040Ab2FYOZS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 10:25:18 -0400
Received: by qaeb19 with SMTP id b19so1516625qae.11
        for <linux-media@vger.kernel.org>; Mon, 25 Jun 2012 07:25:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1206251540490.29019@axis700.grange>
References: <CAH9_wRP4+hzFpCdcZWmyyTZpTTFi+9wyTJxX2vPd+3r0QNhLkA@mail.gmail.com>
 <CAKnK67Qdte8qJ9L18OL2ft=YaF4YEAD-5rTP_bk7+_nQAn4u+A@mail.gmail.com>
 <Pine.LNX.4.64.1205072321530.3564@axis700.grange> <CAKnK67SpO-roU_d_5DV4bq4J5URX0Niw=hCjXY3N=GUAumZLig@mail.gmail.com>
 <Pine.LNX.4.64.1206251540490.29019@axis700.grange>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Mon, 25 Jun 2012 09:24:54 -0500
Message-ID: <CAKnK67Rdxfjvk25uy5cLhVmpK3bWyyN_P5nCAnHeZZw9UAHWVQ@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] (tentative) Android generic V4L2 camera HAL
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sriram V <vshrirama@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sergio Aguirre <sergio.a.aguirre@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(+ My gmail address, please start using that address from next week
on, since I'm leaving TI)

Hi Guennadi,

Thanks a lot for sharing these! Nice job.

I immediately noticed you have changes on hardware/ti/omap4xxx/
subproject. So, Which devices did you used for testing this?

I got confused since you had changes for the Samsung Nexus S, which
has an Exynos chip...

And you also have this Renesas Mackerel, which seems to use a SuperH 7372.

Or maybe you just patched the omap4xxx related file to fix a build :)

Regards,
Sergio

On Mon, Jun 25, 2012 at 8:55 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi all
>
> It's been a while since I've actually done this work. We have been waiting
> for various formalities to be resolved to be able to publish this work
> upstream. There are still a couple of formal issues to sort out before we
> can begin the submission process, but at least it has been decided to
> release patches for independent review and testing.
>
> For now I've uploaded a development snapshot to
>
> http://download.open-technology.de/android/20120625/
>
> In the future we probably will provide git trees at least for the
> system/media/v4l_camera development.
>
> Enjoy:-) Any comments welcome.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
