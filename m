Return-path: <mchehab@pedra>
Received: from tango.tkos.co.il ([62.219.50.35]:46812 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab0HWELo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Aug 2010 00:11:44 -0400
Date: Mon, 23 Aug 2010 07:11:18 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 0/4] mx2_camera: mx25 fixes and enhancements
Message-ID: <20100823041117.GA20026@jasper.tkos.co.il>
References: <cover.1280229966.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1280229966.git.baruch@tkos.co.il>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hi Guennadi,

On Tue, Jul 27, 2010 at 03:06:06PM +0300, Baruch Siach wrote:
> The first 3 pathces in this series are fixes for the mx2_camera driver which is 
> going upstream via the imx git tree. The last patch implements forced active 
> buffer termination on mx25.

Ping?

> Baruch Siach (4):
>   mx2_camera: fix a race causing NULL dereference
>   mx2_camera: return IRQ_NONE when doing nothing
>   mx2_camera: fix comment typo
>   mx2_camera: implement forced termination of active buffer for mx25
> 
>  drivers/media/video/mx2_camera.c |   34 ++++++++++++++++++++++++++--------
>  1 files changed, 26 insertions(+), 8 deletions(-)

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
