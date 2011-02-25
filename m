Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63738 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab1BYOmD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 09:42:03 -0500
Received: by yxs7 with SMTP id 7so746105yxs.19
        for <linux-media@vger.kernel.org>; Fri, 25 Feb 2011 06:42:02 -0800 (PST)
From: Ivan Nazarenko <ivan.nazarenko@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: MT9P031 camera
Date: Fri, 25 Feb 2011 11:41:56 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251141.56933.ivan.nazarenko@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dear Dr. Guennadi.

I have similar set-up as Mr. Valentini - a Beagleboard XM + leopard imaging 
mt0p031 camera.

Could you send me those patches too?

Regards,

Ivan



> On Fri, 18 Feb 2011, Juliano Valentini wrote:
> 
> > Dears,
> > 
> > I'm trying to apply Guennadi's patch
> > (http://download.open-technology.de/BeagleBoard_xM-MT9P031/linux-2.6-
omap3isp-bbxm-mt9p031.gitdiff)
> > to official 2.6.37.1 Kernel version.
> 
> No, this cannot work. That kernel patch requires media-controller and 
> omap3isp, so, it is based on the omap3isp branch of the development tree 
> by Laurent Pinchart:
> 
> git://linuxtv.org/pinchartl/media.git
> 
> But that tree has been rebased since then, so, I wouldn't expect that 
> patch to apply cleanly, porting it to the current kernel would require a 
> non-zero development effort.
> 
> > I suppose that kernel version is wrong or missing previous patches
> > (see result at the end).
> > I have to make it work:  MT9P031 SoC camera module on Beagleboard Xm.
> > Could somebody help me? Where/how can I get the right kernel version?
> 
> I'll send you a tarball of those "old" patches off-list.
> 
> Thanks
> Guennadi
> 
