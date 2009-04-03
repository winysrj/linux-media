Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42572 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZDCMcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 08:32:41 -0400
Received: by fxm2 with SMTP id 2so959641fxm.37
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 05:32:38 -0700 (PDT)
Message-ID: <49D60162.2020907@gmail.com>
Date: Fri, 03 Apr 2009 15:30:26 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
References: <20090403113054.11098.67516.stgit@localhost.localdomain> <Pine.LNX.4.64.0904031352350.4729@axis700.grange> <20090403122939.GT23731@pengutronix.de>
In-Reply-To: <20090403122939.GT23731@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sascha Hauer wrote:
> On Fri, Apr 03, 2009 at 02:15:34PM +0200, Guennadi Liakhovetski wrote:
>> On Fri, 3 Apr 2009, Darius Augulis wrote:
>>
>>> From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>>>
>>> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
>>> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
>> Ok, I'll just swap these two Sob's to reflect the processing chain, add a 
>> description like
>>
>> Add support for CMOS Sensor Interface on i.MX1 and i.MXL SoCs.
>>
>> and fix a couple of trivial conflicts, which probably appear, because you 
>> based your patches on an MXC tree, and not on current linux-next. 
>> Wondering, if it still will work then... At least it compiles. BTW, should 
>> it really also work with IMX? Then you might want to change this
>>
>> 	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
>>
>> to
>>
>> 	depends on VIDEO_DEV && (ARCH_MX1 || ARCH_IMX) && SOC_CAMERA
> 
> This shouldn't be necessary. ARCH_IMX does not have the platform part to
> make use of this driver and will never get it.
> 
>> but you can do this later, maybe, when you actually get a chance to test 
>> it on IMX (if you haven't done so yet).
>>
>> Sascha, we need your ack for the ARM part.
> 
> I'm OK with this driver: I have never worked with FIQs though so I can't
> say much to it.

At least I can confirm it worked well with 2.6.28.5 kernel version.

> 
> Sascha
> 

