Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:54657 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2HXN2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 09:28:44 -0400
Date: Fri, 24 Aug 2012 15:28:39 +0200
From: Anatolij Gustschin <agust@denx.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>, dzu@denx.de
Subject: Re: [PATCH 1/3] mt9v022: add v4l2 controls for blanking and other
 register settings
Message-ID: <20120824152839.62ef31e9@wker>
In-Reply-To: <Pine.LNX.4.64.1208241227140.20710@axis700.grange>
References: <1345799431-29426-1-git-send-email-agust@denx.de>
	<1345799431-29426-2-git-send-email-agust@denx.de>
	<Pine.LNX.4.64.1208241227140.20710@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, 24 Aug 2012 13:08:52 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
...
> > +#define MT9V022_HORIZONTAL_BLANKING_MIN	43
> > +#define MT9V022_HORIZONTAL_BLANKING_MAX	1023
> > +#define MT9V022_HORIZONTAL_BLANKING_DEF	94
> > +#define MT9V022_VERTICAL_BLANKING_MIN	2
> 
> Interesting, in my datasheet min is 4. Maybe 4 would be a safer bet then.

The legal range in the datasheet here is 2-3000. The datasheet
states that the minimal value must be 4 only if "show dark rows"
control bit is set (it is unset by default).

...
> > +#define V4L2_CID_REG32			(V4L2_CTRL_CLASS_CAMERA | 0x1001)
> > +#define V4L2_CID_ANALOG_CONTROLS	(V4L2_CTRL_CLASS_CAMERA | 0x1002)
> 
> Sorry, no again. The MT9V022_ANALOG_CONTROL register contains two fields: 
> anti-eclipse and "anti-eclipse reference voltage control," don't think 
> they should be set as a single control value. IIUC, controls are supposed 
> to control logical parameters of the system. In this case you could 
> introduce an "anti-eclipse reference voltage" control with values in the 
> range between 0 and 2250mV, setting it to anything below 1900mV would turn 
> the enable bit off. Would such a control make sense? Then you might want 
> to ask on the ML, whether this control would make sense as a generic one, 
> not mt9v022 specific.

It probably makes sense since other sensors also have anti-eclipse control
registers.

...
> >  	if (mt9v022->hdl.error) {
> >  		int err = mt9v022->hdl.error;
> >  
> > +		dev_err(&client->dev, "hdl init err %d\n", err);
> 
> That's not very clear IMHO. "hdl" isn't too specific, just "control 
> initialisation?"

Ok, I'll fix it.

Thanks,

Anatolij
