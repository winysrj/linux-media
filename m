Return-path: <mchehab@pedra>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37686 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab1DHPaz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Apr 2011 11:30:55 -0400
Received: by gyd10 with SMTP id 10so1466377gyd.19
        for <linux-media@vger.kernel.org>; Fri, 08 Apr 2011 08:30:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104081707.17576.laurent.pinchart@ideasonboard.com>
References: <BANLkTin35p+xPHWkf3WsGNPzL9aeUwsazQ@mail.gmail.com>
	<201104081707.17576.laurent.pinchart@ideasonboard.com>
Date: Fri, 8 Apr 2011 17:30:54 +0200
Message-ID: <BANLkTi=NTHHyGRhCff+wvXWL4pD+Dv4b8w@mail.gmail.com>
Subject: Re: mt9t111 sensor on Beagleboard xM
From: javier Martin <javier.martin@vista-silicon.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 8 April 2011 17:07, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Javier,
>
> On Friday 08 April 2011 17:02:48 javier Martin wrote:
>> Hi,
>> I've just received a LI-LBCM3M1 camera module from Leopard Imaging and
>> I want to test it with my Beagleboard xM. This module has a mt9t111
>> sensor.
>>
>> At first glance, this driver
>> (http://lxr.linux.no/#linux+v2.6.38/drivers/media/video/mt9t112.c)
>> supports mt9t111 sensor and uses both soc-camera and v4l2-subdev
>> frameworks.
>> I am trying to somehow connect this sensor with the omap3isp driver
>> recently merged (I'm working with latest mainline kernel), however, I
>> found an issue when trying to pass "mt9t112_camera_info" data to the
>> sensor driver in my board specific file.
>>
>> It seems that this data is passed through soc-camera but omap3isp
>> doesn't use soc-camera. Do you know what kind of changes are required
>> to adapt this driver so that it can be used with omap3isp?
>
> The OMAP3 ISP driver isn't compatible with the soc-camera framework, as you
> correctly noticed. You will need to port the MT9T111 driver to pad-level
> subdev operations.
>
> You can find a sensor driver (MT9V032) implementing pad-level subdev
> operations at
> http://git.linuxtv.org/pinchartl/media.git?a=commit;h=940b87a5cb7ea3f3cff16454e9085e33ab340064
>
> --
> Regards,
>
> Laurent Pinchart
>

Hi Laurent,
thank you for your quick answer.

Does the fact of adding pad-level subdev operations for the sensor
break  old way of doing things?
I mean, if I port MT9T111 driver to pad-level subdev operations would
it be accepted for mainline or would it be rejected since it breaks
something older?

Thank you,

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
