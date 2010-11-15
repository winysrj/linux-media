Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:37969 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757091Ab0KOOU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:20:27 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 15 Nov 2010 08:20:22 -0600
Subject: RE: [omap3isp RFC][PATCH 02/10] omap3isp: ccdc: Write
 SYN_MODE.INPMOD based on fmt
Message-ID: <A24693684029E5489D1D202277BE894473777D58@dlee02.ent.ti.com>
References: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
 <1289596693-27660-3-git-send-email-saaguirre@ti.com>
 <201011151136.58000.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011151136.58000.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Monday, November 15, 2010 4:37 AM
> To: Aguirre, Sergio
> Cc: linux-media@vger.kernel.org
> Subject: Re: [omap3isp RFC][PATCH 02/10] omap3isp: ccdc: Write
> SYN_MODE.INPMOD based on fmt
> 
> Hi Sergio,
> 
> Thanks for the patch.

Thanks for reviewing.

> 
> On Friday 12 November 2010 22:18:05 Sergio Aguirre wrote:
> > This takes into account the input format to select the
> > adequate configuration for SYNC mode.
> >
> > Also, change bitmask ISPCCDC_SYN_MODE_INPMOD_MASK to be
> > more consistent with other bitmasks.
> 
> Could you please squash this with the previous patch ?

Sure. I will resend the updated patchset in a couple of minutes.

Regards,
Sergio

> 
> --
> Regards,
> 
> Laurent Pinchart
