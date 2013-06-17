Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:43319 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab3FQGWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 02:22:12 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1306170805390.22409@axis700.grange>
References: <1371106793-25071-1-git-send-email-horms+renesas@verge.net.au>
	<1371106793-25071-15-git-send-email-horms+renesas@verge.net.au>
	<Pine.LNX.4.64.1306132128370.3777@axis700.grange>
	<CANqRtoSx4Jf_EfG3LvkpoOED4-SuOdWjRedz-RbwGCOcOeP-Xg@mail.gmail.com>
	<Pine.LNX.4.64.1306141123380.6920@axis700.grange>
	<CANqRtoRXBupbbU_cq257p5usu8F5975NFDenkOx1qTvYZaxF2w@mail.gmail.com>
	<Pine.LNX.4.64.1306170805390.22409@axis700.grange>
Date: Mon, 17 Jun 2013 15:22:10 +0900
Message-ID: <CANqRtoSd5CdU9YjFjih_kFuoby2dWVapt3RJBmgRR_WizbtxGg@mail.gmail.com>
Subject: Re: [PATCH 14/15] ARM: shmobile: Remove AP4EVB board support
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Simon Horman <horms+renesas@verge.net.au>,
	Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
	SH-Linux <linux-sh@vger.kernel.org>,
	"arm@kernel.org" <arm@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Magnus Damm <damm@opensource.se>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 17, 2013 at 3:12 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 17 Jun 2013, Magnus Damm wrote:
>
> [snip]
>
>> So Guennadi, if you want to keep this board then you have to step up
>> and fix things. If not then there is no point in keeping it.
>
> Ok, after a private discussion we agreed to remove the board, which will
> also make the drivers for the Renesas sh-/r-mobile CSI2 interface and for
> the Sony IMX074 sensor untestable and susceptible to removal. Also
> multi-subdevice support in soc-camera now will lose its only use and can
> become broken. I will also drop CSI2 and AP4EVB patches from my V4L2 clock
> / async probing series.

Thanks for writing this summary. It matches my understanding.

It is unfortunate, but it seems to me that the camera sensor has to be
tested on another platform. Regarding the CSI2 interface, as we
discussed, this IP still exists in newer SoCs so because of that I
recommend you to try to request newer hardware for future testing.

About multi-subdevice and your ongoing work with V4L2 clock / async
probing, please select a more recent hardware platform.

Thanks,

/ magnus
