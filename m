Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51444 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaIRJkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 05:40:14 -0400
Received: by mail-pd0-f169.google.com with SMTP id fp1so1060621pdb.14
        for <linux-media@vger.kernel.org>; Thu, 18 Sep 2014 02:40:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <25198985.8uoHdSYb8S@avalon>
References: <CAH9_wRM_wd_GkS=j-7pkYTFRg4U1oN=NO+Wfhp56vKturYb+cg@mail.gmail.com>
	<25198985.8uoHdSYb8S@avalon>
Date: Thu, 18 Sep 2014 15:10:13 +0530
Message-ID: <CAH9_wRPyqXWa7-sP2u2BXeM5ecwT8ZBpid6xWQ6aiWDQq-4jEQ@mail.gmail.com>
Subject: Re: OMAP3 Multiple camera support
From: Sriram V <vshrirama@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

What you are essentially saying is

CSI2A => Smart Sensor (YUV422)
CSI2C => Sensor that gives out RAW Bayer.

I guess this is a driver limitation? Am i correct?

Also, Can i have something like this?

SMART Sensor => CSI2A => H3A => MEM (Can i have this)
CSI2C => ISP => H3A => MEM

Can't i have H3A for both the pipelines?
Or

Can i enable H3A on the fly for both the sensors? One After the other?

Regards,
Sriram


On Thu, Sep 18, 2014 at 1:55 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Sriram,
>
> On Wednesday 17 September 2014 23:06:42 Sriram V wrote:
>> Hi
>>
>> Does OMAP3 camera driver support multiple cameras at the same time.
>>
>> As i understand - You can have simultaneous YUV422 (Directly to memory)
>> and another one passing through camera controller ISP?
>>
>> I Also, wanted to check if anyone has tried having multiple cameras on omap3
>> with the existing driver.
>
> The driver does support capturing from multiple cameras at the same time,
> provided one of them is connected to the CSI2A receiver. You can then capture
> raw frames from the CSI2A receiver output while processing frames from the
> other camera (connected to CSI1/CCP2, CSI2C or parallel interface) using the
> whole ISP pipeline.
>
> Please note that the consumer OMAP3 variants are documented by TI as not
> including the CSI receivers. However, several developers have reported that
> the receivers are present and usable at least in some of the chips.
>
> --
> Regards,
>
> Laurent Pinchart
>



-- 
Regards,
Sriram
