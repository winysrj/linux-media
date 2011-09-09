Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64861 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460Ab1IISXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 14:23:44 -0400
Received: by eyx24 with SMTP id 24so1510464eyx.19
        for <linux-media@vger.kernel.org>; Fri, 09 Sep 2011 11:23:43 -0700 (PDT)
Message-ID: <4E6A59AA.3060703@gmail.com>
Date: Fri, 09 Sep 2011 20:23:38 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 08/13 v3] ov6650: convert to the control framework.
References: <1315471446-17890-1-git-send-email-g.liakhovetski@gmx.de> <1315471446-17890-9-git-send-email-g.liakhovetski@gmx.de> <201109091907.05823.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1109091947540.915@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109091947540.915@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/09/2011 08:01 PM, Guennadi Liakhovetski wrote:
> Hi Janusz
> 
> On Fri, 9 Sep 2011, Janusz Krzysztofik wrote:
> 
>> On Thu, 8 Sep 2011 at 10:44:01 Guennadi Liakhovetski wrote:
>>> From: Hans Verkuil<hans.verkuil@cisco.com>
>>>
>>> Signed-off-by: Hans Verkuil<hans.verkuil@cisco.com>
>>> [g.liakhovetski@gmx.de: simplified pointer arithmetic]
>>> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>>
>> Hi,
>> I've successfully tested this one for you, to the extent possible using
>> mplayer, i.e., only saturation, hue and brightness controls, and an
>> overall functionality.
> 
> Thanks for testing and reviewing!
> 
>> Modifications to other (not runtime tested) controls look good to me,
>> except for one copy-paste mistake, see below. With that erratic REG_BLUE
>> corrected:
>>
>> Acked-by: Janusz Krzysztofik<jkrzyszt@tis.icnet.pl>
>>
>> There are also a few minor comments for you to consider.
> 
> Well, some of them are not so minor, I would say;-) But I personally would
> be happy to have this just as an incremental patch. Would you like to
> prepare one or should I do it?
> 
> I basically agree with all your comments apart from maybe
> 
> [snip]
> 
>>> @@ -1176,9 +1021,11 @@ static int ov6650_probe(struct i2c_client *client,
>>>   	priv->colorspace  = V4L2_COLORSPACE_JPEG;
>>>
>>>   	ret = ov6650_video_probe(icd, client);
>>> +	if (!ret)
>>> +		ret = v4l2_ctrl_handler_setup(&priv->hdl);
>>
>> Are you sure the probe function should fail if v4l2_ctrl_handler_setup()
>> fails? Its usage is documented as optional.
> 
> Not sure what the standard really meant, but it looks like this is done in
> all patches in this series. So, we'd have to change this everywhere. Most
> other drivers indeed do not care.

The usage of v4l2_ctrl_handler_setup() is optional, but if this function
is not used, then AFAIU the driver writer needs to ensure the control's 
values after the device is initialized are exactly as those specified during
the control creation. Of course v4l2_ctrl_handler_setup() failure might
mean s_ctrl op failed, which might be caused by some H/W access errors.
So IMHO it is always a good idea to check the return value if we know
the batch controls setup shouldn't fail.

--
Regards,
Sylwester
