Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:36149 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1DKTXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 15:23:53 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c
Date: Mon, 11 Apr 2011 20:40:07 +0200
Cc: "Aguirre, Sergio" <saaguirre@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange> <BANLkTikQSaUKtNZCexhKeNEPM+id+J_2gw@mail.gmail.com> <Pine.LNX.4.64.1104111829500.20798@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104111829500.20798@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104112040.08077.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia poniedziałek 11 kwiecień 2011 o 18:58:51 Guennadi Liakhovetski napisał(a):
> On Mon, 11 Apr 2011, Aguirre, Sergio wrote:
> > 
> > Ok. And how about the attached patch? Would that work?
> 
> Yes, I think, ot would work too, only the call to
> soc_camera_xlate_by_fourcc() in the S_FMT case is superfluous, after
> ici->ops->set_fmt() we already have it in icd->current_fmt->host_fmt.
> Otherwise - yes, we could do it this way too. Janusz, could you test,
> please?

Looks like not based on the current mainline (-rc2) tree:

  CHECK   drivers/media/video/soc_camera.c
drivers/media/video/soc_camera.c:146:9: error: undefined identifier 'pixfmtstr'
  CC      drivers/media/video/soc_camera.o
drivers/media/video/soc_camera.c: In function 'soc_camera_try_fmt':
drivers/media/video/soc_camera.c:146: error: implicit declaration of function 'pixfmtstr'
drivers/media/video/soc_camera.c:146: warning: too few arguments for format
drivers/media/video/soc_camera.c: In function 'soc_camera_try_fmt_vid_cap':
drivers/media/video/soc_camera.c:180: warning: unused variable 'ici'

Thanks,
Janusz
