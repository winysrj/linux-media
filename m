Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:23031 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZCEHbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 02:31:19 -0500
Message-ID: <49AF7FAC.1010004@maxwell.research.nokia.com>
Date: Thu, 05 Mar 2009 09:30:52 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
CC: "DongSoo(Nathaniel) Kim" <dongsoo.kim@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Toivonen Tuukka Olli Artturi <tuukka.o.toivonen@nokia.com>,
	Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: Re: [RFC 0/9] OMAP3 ISP and camera drivers
References: <19F8576C6E063C45BE387C64729E73940427BCA20A@dbde02.ent.ti.com>
In-Reply-To: <19F8576C6E063C45BE387C64729E73940427BCA20A@dbde02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hiremath, Vaibhav wrote:
> 
> Thanks,
> Vaibhav Hiremath
> 
>> -----Original Message-----
>> From: DongSoo(Nathaniel) Kim [mailto:dongsoo.kim@gmail.com]
>> Sent: Thursday, March 05, 2009 5:41 AM
>> To: Sakari Ailus
>> Cc: Hiremath, Vaibhav; linux-media@vger.kernel.org; linux-
>> omap@vger.kernel.org; Aguirre Rodriguez, Sergio Alberto; Toivonen
>> Tuukka Olli Artturi; Hiroshi DOYU
>> Subject: Re: [RFC 0/9] OMAP3 ISP and camera drivers
>>
>> Hi Sakari,
>>
>> I'm also facing same issue with Hiremath.
>>
>> Here you are my kernel stack dump.
>>
> [Hiremath, Vaibhav] I was getting same kernel crash,  The reason is -
> 
> Since  isp_probe doesn't get called, leaving omap3isp = NULL. So isp_get will return -EBUSY from the very beginning of function.  And the function "omap34xxcam_device_register" which calls isp_get tries to access vdev->vfd->dev where it crashes. Which is completely wrong, since the vfd gets initialize later part of function
> 
> 
> if (hwc.dev_type == OMAP34XXCAM_SLAVE_SENSOR) {
>     rval = isp_get();
>     if (rval < 0) {
>         dev_err(&vdev->vfd->dev, "can't get ISP, sensor init 					failed\n");
> [Vaibhav] - Here it crashes.
>          goto err;
>      }
> }
> 
> There are some instances where vdev->vfd is being accessed before initializing.

Ooops.

Some parts of those dev_* were just mechanically changed from something 
else. And I think Alexey Klimov already notified me about that problem. 
I'm surprised that it was hit it so soon. ;)

Just removing the dev_err helps to resolve the crash, I guess. You could 
use late_initcall instead of module_init in the sensor, but that's just 
a hack, too.

If you are using modules, please load iommu2 and omap3-iommu before isp-mod.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
