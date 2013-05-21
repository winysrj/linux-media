Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:35935 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab3EUMOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 08:14:15 -0400
In-reply-to: <OF0ABE628B.1C271A20-ON80257B72.002ED824-80257B72.003627CD@LocalDomain>
References: <201305180101.11383.sergei.shtylyov@cogentembedded.com>
 <OFC9B7B505.2CDF0AA3-ON80257B71.00291B65-80257B71.002952EB@eu.necel.com>
 <519A1FFC.6000304@cogentembedded.com>
 <OF0ABE628B.1C271A20-ON80257B72.002ED824-80257B72.003627CD@LocalDomain>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	vladimir.barinov@cogentembedded.com
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, magnus.damm@gmail.com, matsu@igel.co.jp,
	mchehab@redhat.com
MIME-version: 1.0
From: phil.edworthy@renesas.com
Subject: Re: [PATCH v5] V4L2: soc_camera: Renesas R-Car VIN driver
Message-id: <OF7D5F7F7E.CF4ED120-ON80257B72.0042ED42-80257B72.004332EB@eu.necel.com>
Date: Tue, 21 May 2013 13:13:52 +0100
Content-type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei, Vladimir,

> > >> Subject: [PATCH v5] V4L2: soc_camera: Renesas R-Car VIN driver
> > 
> > >> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> > 
> > >> Add Renesas R-Car VIN (Video In) V4L2 driver.
> > 
> > >> Based on the patch by Phil Edworthy <phil.edworthy@renesas.com>.
> > 
> > > I've seen old patches that add VIN to the Marzen board, do you have 
an
> > > updated version?
> > 
> >     The last version of that patchset is 4, here it is archived:
> > 
> > http://marc.info/?l=linux-sh&m=136865481429756
> > http://marc.info/?l=linux-sh&m=136865499029807
> > http://marc.info/?l=linux-sh&m=136865509129843
> > http://marc.info/?l=linux-sh&m=136865520029900

> First of all, thank you for your work on this driver.
> 
> I have tried your patches on the Marzen board using an Expansion 
> Board with an OmniVision 10635 camera (progressive BT656), using an 
> out-of-tree driver. There appears to be an issue with the interrupt 
> handling compared to my original driver.
> 
> Using a simple test app I wrote, I get an unhandled irq if the app 
> does some work after stopping the capture. In this case, the work 
> after capture is storing a captured image to a file. As a dirty hack
> to see what's actually being captured, I just commented out the code
> that checks the interrupt status:
> // if (!int_status)
> //  goto done;
> This allows me to save the captured image. However, this shows about
> 2/3rds valid picture data (though it looks vertically shifted), with
> the rest black. Also, a couple of other lines are black.
> 
> I realise that you don't have the Marzen Expansion Board & don't 
> have an ov10635 camera. However, unfortunately, I don't have much 
> time that I can spend on this. Do any of the boards you have use a 
> progressive camera?

Oops, the comments about the captured image contents are my fault. 
However, the unhandled irq after stopping capture is still an issue.

Regards
Phil

