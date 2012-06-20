Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58449 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2FTD0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 23:26:50 -0400
Received: by bkcji2 with SMTP id ji2so5768890bkc.19
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 20:26:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
Date: Wed, 20 Jun 2012 00:26:48 -0300
Message-ID: <CAOMZO5AOEdVpSvV2bnbw6bwGb8+83Zji3jkTjH01yaC7pZUGvA@mail.gmail.com>
Subject: Re: [RFC] Support for 'Coda' video codec IP.
From: Fabio Estevam <festevam@gmail.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de, fabio.estevam@freescale.com,
	shawn.guo@linaro.org, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, Jun 19, 2012 at 11:11 AM, Javier Martin
<javier.martin@vista-silicon.com> wrote:
> This patch adds support for the video encoder present
> in the i.MX27. It currently support encoding in H.264 and
> in MPEG4 SP. It's working properly in a Visstrim SM10 platform.
> It uses V4L2-mem2mem framework.
>
> A public git repository is available too:
> git://github.com/jmartinc/video_visstrim.git

I will give it a try and I have some questions:

- How did you generate the VPU firmware?

- Which userspace application did you use for testing the encoding? Is
Gstreamer OK to test it?

Thanks,

Fabio Estevam
