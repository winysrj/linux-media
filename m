Return-path: <mchehab@pedra>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13315 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637Ab1F2Tg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 15:36:27 -0400
From: Andrew Chew <AChew@nvidia.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"mchehab@redhat.com" <mchehab@redhat.com>,
	"olof@lixom.net" <olof@lixom.net>
Date: Wed, 29 Jun 2011 12:36:23 -0700
Subject: RE: [PATCH 4/6 v3] [media] ov9740: Remove hardcoded resolution regs
Message-ID: <643E69AA4436674C8F39DCC2C05F76382A76C764BD@HQMAIL03.nvidia.com>
References: <1308871184-6307-1-git-send-email-achew@nvidia.com>
 <1308871184-6307-4-git-send-email-achew@nvidia.com>
 <201106291152.00992.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106291152.00992.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> > +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL1E, 
> scale_input_x >> 8);
> > +	if (ret)
> > +		goto done;
> > +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL1F, 
> scale_input_x & 0xff);
> > +	if (ret)
> > +		goto done;
> > +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL20, 
> scale_input_y >> 8);
> > +	if (ret)
> > +		goto done;
> > +	ret = ov9740_reg_write(client, OV9740_ISP_CTRL21, 
> scale_input_y & 0xff);
> > +	if (ret)
> > +		goto done;
> 
> Now that we know what control registers 1e to 21 are for, 
> what about renaming 
> them ? Are they called CTRL1E to CTRL21 in the vendor documentation ?

Yes, that's what they're called in the vendor documentation, so I'd rather not make something up.