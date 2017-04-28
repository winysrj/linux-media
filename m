Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:45704 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937572AbdD1EvB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 00:51:01 -0400
Subject: Re: [PATCH] [media] pxa_camera: fix module remove codepath for v4l2
 clock
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <4391b498-0a75-ff42-6a7e-65aef0fada07@tul.cz>
 <87efwd1wus.fsf@belgarion.home>
Cc: mchehab@kernel.org, g.liakhovetski@gmx.de,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <c95ef700-d34d-5aa2-ef92-ad1aa7dd5a0d@tul.cz>
Date: Fri, 28 Apr 2017 06:51:56 +0200
MIME-Version: 1.0
In-Reply-To: <87efwd1wus.fsf@belgarion.home>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 27.4.2017 v 21:20 Robert Jarzmik napsal(a):
> Petr Cvek <petr.cvek@tul.cz> writes:
> 
>> The conversion from soc_camera omitted a correct handling of the clock
>> gating for a sensor. When the pxa_camera driver module was removed it
>> tried to unregister clk, but this caused a similar warning:
>>
>>   WARNING: CPU: 0 PID: 6740 at drivers/media/v4l2-core/v4l2-clk.c:278
>>   v4l2_clk_unregister(): Refusing to unregister ref-counted 0-0030 clock!
>>
>> The clock was at time still refcounted by the sensor driver. Before
>> the removing of the pxa_camera the clock must be dropped by the sensor
>> driver. This should be triggered by v4l2_async_notifier_unregister() call
>> which removes sensor driver module too, calls unbind() function and then
>> tries to probe sensor driver again. Inside unbind() we can safely
>> unregister the v4l2 clock as the sensor driver got removed. The original
>> v4l2_clk_unregister() should be put inside test as the clock can be
>> already unregistered from unbind(). If there was not any bound sensor
>> the clock is still present.
>>
>> The codepath is practically a copy from the old soc_camera. The bug was
>> tested with a pxa_camera+ov9640 combination during the conversion
>> of the ov9640 from the soc_camera.
>>
>> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
> 
> Yeah, it's way better with this patch, especially the insmod/rmmod/insmod/rmmod
> test.

I will post some other bugfixes (and feature adding) for pxa_camera soon. Do you wish to be CC'd? 

P.S. Who is the the maintainer of pxa_camera BTW? Still Guennadi Liakhovetski? Basically pxa_camera is no longer part of the soc_camera and MAINTAINERS file does not exactly specify pxa_camera.c (I'm asking because I will send the patch for ov9640 soc_camera removal too :-D).

Best regards,
Petr
