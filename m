Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57811 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752662Ab2G1Qxn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Jul 2012 12:53:43 -0400
Subject: Re: [PATCH] ivtv: Declare MODULE_FIRMWARE usage
From: Andy Walls <awalls@md.metrocast.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Date: Sat, 28 Jul 2012 12:52:59 -0400
In-Reply-To: <5012B792.20400@canonical.com>
References: <1343327180-94759-1-git-send-email-tim.gardner@canonical.com>
	 <1343341295.2575.18.camel@palomino.walls.org>
	 <5012B792.20400@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1343494380.2476.12.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2012-07-27 at 09:45 -0600, Tim Gardner wrote:
> On 07/26/2012 04:21 PM, Andy Walls wrote:
> > On Thu, 2012-07-26 at 12:26 -0600, Tim Gardner wrote:
> >> Cc: Andy Walls <awalls@md.metrocast.net>
> >> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> >> Cc: ivtv-devel@ivtvdriver.org
> >> Cc: linux-media@vger.kernel.org
> >> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> >> ---
> >>  drivers/media/video/ivtv/ivtv-firmware.c |    4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/media/video/ivtv/ivtv-firmware.c b/drivers/media/video/ivtv/ivtv-firmware.c
> >> index 02c5ade..6ec7705 100644
> >> --- a/drivers/media/video/ivtv/ivtv-firmware.c
> >> +++ b/drivers/media/video/ivtv/ivtv-firmware.c
> >> @@ -396,3 +396,7 @@ int ivtv_firmware_check(struct ivtv *itv, char *where)
> >>  
> >>  	return res;
> >>  }
> >> +
> >> +MODULE_FIRMWARE(CX2341X_FIRM_ENC_FILENAME);
> >> +MODULE_FIRMWARE(CX2341X_FIRM_DEC_FILENAME);
> >> +MODULE_FIRMWARE(IVTV_DECODE_INIT_MPEG_FILENAME);
> > 
> > Only the PVR-350, based on the iTVC-15/CX23415 chip, needs the
> > CX2341X_FIRM_DEC_FILENAME and IVTV_DECODE_INIT_MPEG_FILENAME.  (And even
> > in the case of that card, not having the IVTV_DECODE_INIT_MPEG_FILENAME
> > file is non-fatal.)
> > 
> > I would not want anything in user-space or kernel space preventing the
> > ivtv module from loading, if some of those files don't exist.
> > 
> > Regards,
> > Andy
> > 
> 
> MODULE_FIRMWARE is informational only and has no runtime impact.

OK.

Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

> 
> rtg


