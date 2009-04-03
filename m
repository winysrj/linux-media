Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55305 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbZDCMyt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 08:54:49 -0400
Received: by fxm2 with SMTP id 2so967881fxm.37
        for <linux-media@vger.kernel.org>; Fri, 03 Apr 2009 05:54:47 -0700 (PDT)
Message-ID: <49D60692.9050204@gmail.com>
Date: Fri, 03 Apr 2009 15:52:34 +0300
From: Darius Augulis <augulis.darius@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
References: <20090403113054.11098.67516.stgit@localhost.localdomain> <Pine.LNX.4.64.0904031352350.4729@axis700.grange> <20090403122939.GT23731@pengutronix.de> <Pine.LNX.4.64.0904031437540.4729@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0904031437540.4729@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Fri, 3 Apr 2009, Sascha Hauer wrote:
>
>   
>> On Fri, Apr 03, 2009 at 02:15:34PM +0200, Guennadi Liakhovetski wrote:
>>     
>>> Wondering, if it still will work then... At least it compiles. BTW, should 
>>> it really also work with IMX? Then you might want to change this
>>>
>>> 	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
>>>
>>> to
>>>
>>> 	depends on VIDEO_DEV && (ARCH_MX1 || ARCH_IMX) && SOC_CAMERA
>>>       
>> This shouldn't be necessary. ARCH_IMX does not have the platform part to
>> make use of this driver and will never get it.
>>     
>
> Confused... Then why the whole that "IMX/MX1" in the driver? And why will 
> it never get it - are they compatible or not? Or just there's no demand / 
> chips are EOLed or something...
>
>   

in Linux kernel "imx" is the old name of "mx1".
mx1 contains of two processors: i.MX1 and i.MXL.

>>> but you can do this later, maybe, when you actually get a chance to test 
>>> it on IMX (if you haven't done so yet).
>>>
>>> Sascha, we need your ack for the ARM part.
>>>       
>> I'm OK with this driver: I have never worked with FIQs though so I can't
>> say much to it.
>>     
>
> Ok, I take it as an "Acked-by" then:-)
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
>
>   

