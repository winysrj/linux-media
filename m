Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:44188 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab2BPTSz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 14:18:55 -0500
Date: Thu, 16 Feb 2012 20:33:21 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	g.liakhovetski@gmx.de, javier.martin@vista-silicon.com,
	kernel@pengutronix.de
Subject: Re: [PATCH] media: video: mx2_camera: Remove ifdef's
Message-ID: <20120216183320.GB3119@tarshish>
References: <1329416739-23566-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329416739-23566-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Thu, Feb 16, 2012 at 04:25:39PM -0200, Fabio Estevam wrote:
> As we are able to build a same kernel that supports both mx27 and mx25, we should remove
> the ifdef's for CONFIG_MACH_MX27 in the mx2_camera driver.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Baruch Siach <baruch@tkos.co.il>

baruch 

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
