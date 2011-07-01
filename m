Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60701 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab1GAMy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jul 2011 08:54:28 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNN00ETFNUJ0K@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 13:54:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNN007IFNUIZL@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Jul 2011 13:54:18 +0100 (BST)
Date: Fri, 01 Jul 2011 14:54:17 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC v4] V4L: add media bus configuration subdev operations
In-reply-to: <Pine.LNX.4.64.1107010036390.20437@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com,
	Stan <svarbanov@mm-sol.com>, Hans Verkuil <hansverk@cisco.com>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Message-id: <4E0DC379.4060807@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <Pine.LNX.4.64.1106291819520.12577@axis700.grange>
 <4E0CEFEB.2080005@gmail.com> <Pine.LNX.4.64.1107010036390.20437@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 07/01/2011 12:42 AM, Guennadi Liakhovetski wrote:
...
>>> +/**
>>> + * v4l2_mbus_type - media bus type
>>> + * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
>>> + * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
>>> + *			also be used for BT.1120
>>> + * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
>>> + */
>>> +enum v4l2_mbus_type {
>>> +	V4L2_MBUS_PARALLEL,
>>> +	V4L2_MBUS_BT656,
>>> +	V4L2_MBUS_CSI2,
>>
>> How about internal connections between processing blocks inside SoCs?
>> Don't we want to also list those here? I mean direct connections
>> like Preview Engine -> Resizer in TI SoCs or Display Mixer -> Video Capture
>> Engine in Samsung SoCs.
>> If there is no all possible bus types in this list I can't see how
>> driver's for such hardware could be converted to use this new interface. 
>>
>> Perhaps we could add something like
>> V4L2_MBUS_INTERNAL or V4L2_MBUS_USER1...?
> 
> Maybe. But again, this patch is not aiming at covering all possible cases. 
> We discuss it to avoid stupid or wrong things. Correct but incomplete 
> things can always be added. So, once someone get to implement such a 
> connection, using this API, they will just add one more type here. Why I'm 

Sure, we can add more types when needed. The only parameters I'm aware of
at the moment for such an internal bus is clock type and clock frequency.
It certainly needs more investigation and discussing.

Your patch looks OK to me, except is has only a declaration of
v4l2_mbus_config_compatible() and the implementation is lost somewhere.
I guess we'll need to replace the "flags" field with an union ewentually,
but it would be good to get the patch merged in this form so we can finally
move forward with the sensor drivers standardization.

> also unsure whether and how to add it now is, that these types define bus 
> properties. E.g., on CSI-2 you have up to 4 data lanes, a clock lane with 
> certain properties etc. What properties does the "internal" bus have? I 
> would leave it out until we really get to implement it.

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
