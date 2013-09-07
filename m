Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52124 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3IGHQM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Sep 2013 03:16:12 -0400
Received: by mail-wi0-f171.google.com with SMTP id hm2so1702041wib.10
        for <linux-media@vger.kernel.org>; Sat, 07 Sep 2013 00:16:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A1C27CCF8AE7654C92DB070B5400692B0A465E@PELCOEMAIL.pelco.org>
References: <52299218.2060002@ti.com> <A1C27CCF8AE7654C92DB070B5400692B0A465E@PELCOEMAIL.pelco.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 7 Sep 2013 12:45:51 +0530
Message-ID: <CA+V-a8szA-YGNH6OWhVETYaoao22A_MmU6bsLEw=pG7GsUQa4A@mail.gmail.com>
Subject: Re: DM365 VPFE Staging Driver
To: "Neff, Bryan" <Bryan.Neff@schneider-electric.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

Thank you for showing interest in using this driver.

Hopefully I'll get this driver out from staging directory to its actual place.

On Fri, Sep 6, 2013 at 9:37 PM, Neff, Bryan
<Bryan.Neff@schneider-electric.com> wrote:
> Hello Prabhakar,
>
[Snip]
>>
>> If you have a few spare minutes, could you explain what I need to do?
>> I've followed the TODO doc and copied the .h files to their respective
>> locations, but I'm unsure about how to modify the Kbuild:
>>
>> 30 - copy vpfe.h from drivers/staging/media/davinci_vpfe/ to
>> 31   include/media/davinci/ folder for building the uImage.
>> 32 - copy davinci_vpfe_user.h from drivers/staging/media/davinci_vpfe/ to
>> 33   include/uapi/linux/davinci_vpfe.h, and add a entry in Kbuild
>> (required
>> 34   for building application).
>> 35 - copy dm365_ipipeif_user.h from drivers/staging/media/davinci_vpfe/ to
>> 36   include/uapi/linux/dm365_ipipeif.h and a entry in Kbuild (required
>> 37   for building application).
>>
>>
>> After I add this, do I need to create a device node or anything else to
>> get this to work?
>>
>>
The current vanilla kernel contains only the driver and _no_ platform changes
required for DM365. The patch [1] adds the platform changes required for the
driver to work , The platform changes patch adds support for tvp514x/tvp7002
and mt9p031 sensor, the patch[2] you can look at the Kbuild changes required.

Let me know if you still need any information.

[1] http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git/commitdiff/1fff194a826e97f9562f0a633945220917d24eec
[2] http://git.linuxtv.org/mhadli/v4l-dvb-davinci_devices.git/commitdiff/06c2d1e1fa7acdbc5b887d896a287bb02e584913

Regards,
--Prabhakar Lad
