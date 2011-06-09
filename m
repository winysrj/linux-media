Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:52776 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1FIImg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 04:42:36 -0400
Date: Thu, 9 Jun 2011 10:42:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <kassey1216@gmail.com>
cc: Kassey Lee <ygli@marvell.com>, linux-media@vger.kernel.org,
	ytang5@marvell.com, corbet@lwn.net, qingx@marvell.com,
	jwan@marvell.com, leiwen@marvell.com
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
In-Reply-To: <BANLkTikS1nhSnrvQv=s4Xe2_Juf1i-xwfg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1106091042100.17738@axis700.grange>
References: <1307530660-25464-1-git-send-email-ygli@marvell.com>
 <Pine.LNX.4.64.1106081322590.24274@axis700.grange>
 <BANLkTikS1nhSnrvQv=s4Xe2_Juf1i-xwfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, 9 Jun 2011, Kassey Lee wrote:

> Guennadi, Jon:
>        thanks!
>        we hope to work out a common ccic core, and then re base the code.

ok, so, we agree, that I don't review your last version, ok?

Thanks
Guennadi

> :
> On Wed, Jun 8, 2011 at 7:30 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi Kassey
> >
> > Thanks for the new version, but, IIUC, you agreed to reimplement your
> > driver on top of a common ccic core, which means, a lot of code will
> > change. So, it doesn't really make much sense now to make and review new
> > stand-alone versions of your driver, right? So, shall we wait until Jon's
> > CCIC code stabilises a bit and you rebase your driver on top of it? Of
> > course, you can also work together with Jon on the drivers to get them
> > faster in shape and in a way, suitable fou you both.
> >
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> -- 
> Best regards
> Kassey
> Application Processor Systems Engineering, Marvell Technology Group Ltd.
> Shanghai, China.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
