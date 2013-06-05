Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab3FEKCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jun 2013 06:02:45 -0400
Date: Wed, 5 Jun 2013 12:02:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-media@vger.kernel.org,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: Re: [PATCH 1/2] [media] soc_camera: mt9t112: Remove empty function
In-Reply-To: <CAK9yfHyUqpF4d_cuwPo-fA5UuCQzfG4-ktyOA716CfN3QgtHLg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1306051201340.19739@axis700.grange>
References: <1369394707-13049-1-git-send-email-sachin.kamat@linaro.org>
 <CAK9yfHyUqpF4d_cuwPo-fA5UuCQzfG4-ktyOA716CfN3QgtHLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin

On Tue, 4 Jun 2013, Sachin Kamat wrote:

> On 24 May 2013 16:55, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > After the switch to devm_* functions, the 'remove' function does
> > not do anything. Delete it.
> >
> > Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> > Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > ---
> >  drivers/media/i2c/soc_camera/mt9t112.c |    6 ------
> >  1 file changed, 6 deletions(-)

[snip]

> Gentle ping on this series  :)

Both these patches are in my queue for 3.11.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
