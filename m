Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39277 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1ENOVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2011 10:21:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Current status report of mt9p031.
Date: Sat, 14 May 2011 16:22:39 +0200
Cc: Chris Rodley <carlighting@yahoo.co.nz>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <935308.40531.qm@web112020.mail.gq1.yahoo.com> <BANLkTimvXHxmZ0io=9ZdCeLzTUQi0+S0bg@mail.gmail.com>
In-Reply-To: <BANLkTimvXHxmZ0io=9ZdCeLzTUQi0+S0bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105141622.39671.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Javier,

On Friday 13 May 2011 08:45:28 javier Martin wrote:
> On 13 May 2011 07:02, Chris Rodley <carlighting@yahoo.co.nz> wrote:
> > On 11/05/11 19:15, javier Martin wrote:
> > 
> > On 11 May 2011 06:54, Chris Rodley <carlighting@yahoo.co.nz> wrote:
> >>  Thanks, sorry I should have spotted that.
> > 
> > Got some shots today. So I have caught up to where you were. Had a bit of
> > messing around to do as my board connects power via gpio switches and I
> > was porting other drivers from 2.6.32.
> > 
> > How are you progressing Javier?
> 
> I'm just waiting for Laurent to clarify an issue about  format matching
> between mt9p031 and omap3isp.
> He claimed to help me this weekend or next week.

I have no mt9p031 here, so I've tried an mt9v032 (752x480 10-bit raw bayer) 
with the latest OMAP3 ISP driver. I had to patch yavta to support 8-bit 
formats, the patch has been pushed to the repository.

Running the following commands captured 4 frames successfully.

./media-ctl -r -l '"mt9v032 3-005c":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP 
CCDC":1->"OMAP3 ISP CCDC output":0[1]'
./media-ctl -f '"mt9v032 3-005c":0[SGRBG10 752x480 (1,5)/752x480], "OMAP3 ISP 
CCDC":0[SGRBG8 752x480], "OMAP3 ISP CCDC":1[SGRBG8 752x480]'

./yavta -p -f SGRBG8 -s 752x480 -n 4 --capture=4 --skip 3 -F `./media-ctl -e 
"OMAP3 ISP CCDC output"`

-- 
Regards,

Laurent Pinchart
