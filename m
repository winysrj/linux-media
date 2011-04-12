Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:51446 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1DLQjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 12:39:40 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [PATCH] V4L: soc-camera: regression fix: calculate .sizeimage in soc_camera.c
Date: Tue, 12 Apr 2011 18:33:01 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1104111054110.18511@axis700.grange> <201104112352.07808.jkrzyszt@tis.icnet.pl> <BANLkTik7YRvvthrSHwMuH_dcDaNzkN96NQ@mail.gmail.com>
In-Reply-To: <BANLkTik7YRvvthrSHwMuH_dcDaNzkN96NQ@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201104121833.01789.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia wtorek 12 kwiecieñ 2011 o 17:39:35 Aguirre, Sergio napisa³(a):
> On Mon, Apr 11, 2011 at 4:52 PM, Janusz Krzysztofik
> 
> <jkrzyszt@tis.icnet.pl> wrote:
> > Dnia poniedzia³ek 11 kwiecieñ 2011 o 22:05:35 Aguirre, Sergio
> > 
> > napisa³(a):
> >> Please find below a refreshed patch, which should be based on
> > 
> >> mainline commit:
> > Hi,
> > This version works for me, and fixes the regression.
> 
> Ok, Thanks for testing.

I forgot to mention: the patch didn't apply cleanly, I had to unwrap a 
few lines manually, so you may want to resend it unwrapped.

Thanks,
Janusz
