Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:45696 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752721AbdEEDMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 May 2017 23:12:55 -0400
Subject: Re: [PATCH 4/4] [media] pxa_camera: Fix a call with an uninitialized
 device pointer
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <cover.1493612057.git.petr.cvek@tul.cz>
 <81365c5e-d102-12ba-777f-47c758416cd8@tul.cz> <87shknz4x6.fsf@belgarion.home>
Cc: linux-media@vger.kernel.org
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <d2bf8952-4b4b-d6f1-45a3-12b9e1b5bd57@tul.cz>
Date: Fri, 5 May 2017 05:14:12 +0200
MIME-Version: 1.0
In-Reply-To: <87shknz4x6.fsf@belgarion.home>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 2.5.2017 v 16:53 Robert Jarzmik napsal(a):
> Petr Cvek <petr.cvek@tul.cz> writes:
> 
>> In 'commit 295ab497d6357 ("[media] media: platform: pxa_camera: make
>> printk consistent")' a pointer to the device structure in
>> mclk_get_divisor() was changed to pcdev_to_dev(pcdev). The pointer used
>> by pcdev_to_dev() is still uninitialized during the call to
>> mclk_get_divisor() as it happens in v4l2_device_register() at the end
>> of the probe. The dev_warn and dev_dbg caused a line in the log:
>>
>> 	(NULL device *): Limiting master clock to 26000000
>>
>> Fix this by using an initialized pointer from the platform_device
>> (as before the old patch).
>>
>> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
> Right, would be good to add to the commit message :
> Fixes: 295ab497d635 ("[media] media: platform: pxa_camera: make printk consistent")
> 

OK I will add it in v2.
