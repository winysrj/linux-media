Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:48884 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbZDJXk6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 19:40:58 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] soc-camera: Convert to a platform driver
References: <Pine.LNX.4.64.0904061207530.4285@axis700.grange>
	<87iqlgkykd.fsf@free.fr> <87skkkdunm.fsf@free.fr>
	<Pine.LNX.4.64.0904081137310.4722@axis700.grange>
	<87hc0xslp1.fsf@free.fr>
	<Pine.LNX.4.64.0904092108150.4841@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Sat, 11 Apr 2009 01:40:47 +0200
In-Reply-To: <Pine.LNX.4.64.0904092108150.4841@axis700.grange> (Guennadi Liakhovetski's message of "Thu\, 9 Apr 2009 21\:09\:15 +0200 \(CEST\)")
Message-ID: <87ws9soz5s.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> On Thu, 9 Apr 2009, Robert Jarzmik wrote:
>
>> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>> 
>
> Did you enable DEBUG? Looks like one of dev_dbg() had a (yet) invalid 
> device pointer. I'll have to try that too.
No, don't think so.

I think that calling mclk_get_divisor() too early, when
pcdev->soc_host.dev is not set, is the issue here (dev_warn is
mclk_get_divisor()).

And for the same price, I'll give you another stack :)
I'll leave that one up to you, as I'm not really confortable with that type of
sequence :
	if (!icd->dev.parent ||
	    to_soc_camera_host(icd->dev.parent)->nr != icd->iface)

[  183.230769] [<bf016128>] (mt9m111_probe+0xcc/0x298 [mt9m111]) from [<c0171a8c>] (i2c_device_probe+0x8c/0x9c)
[  183.238108] [<c0171a8c>] (i2c_device_probe+0x8c/0x9c) from [<c014777c>] (driver_probe_device+0xa4/0x1a8)
[  183.245424] [<c014777c>] (driver_probe_device+0xa4/0x1a8) from [<c0146a28>] (bus_for_each_drv+0x60/0x8c)
[  183.252617] [<c0146a28>] (bus_for_each_drv+0x60/0x8c) from [<c0147994>] (device_attach+0x5c/0x74)
[  183.259792] [<c0147994>] (device_attach+0x5c/0x74) from [<c0146994>] (bus_attach_device+0x44/0x78)
[  183.266944] [<c0146994>] (bus_attach_device+0x44/0x78) from [<c0145368>] (device_add+0x394/0x5ac)
[  183.274084] [<c0145368>] (device_add+0x394/0x5ac) from [<c0172790>] (i2c_attach_client+0x80/0x148)
[  183.281228] [<c0172790>] (i2c_attach_client+0x80/0x148) from [<c0172b14>] (i2c_new_device+0x6c/0x90)
[  183.288340] [<c0172b14>] (i2c_new_device+0x6c/0x90) from [<bf00ccb8>] (soc_camera_probe+0x4c/0x188 [soc_camera])
[  183.295622] [<bf00ccb8>] (soc_camera_probe+0x4c/0x188 [soc_camera]) from [<c014777c>] (driver_probe_device+0xa4/0x1a8)
[  183.302774] [<c014777c>] (driver_probe_device+0xa4/0x1a8) from [<c0146a28>] (bus_for_each_drv+0x60/0x8c)
[  183.309863] [<c0146a28>] (bus_for_each_drv+0x60/0x8c) from [<c0147994>] (device_attach+0x5c/0x74)
[  183.316902] [<c0147994>] (device_attach+0x5c/0x74) from [<c0146994>] (bus_attach_device+0x44/0x78)
[  183.323927] [<c0146994>] (bus_attach_device+0x44/0x78) from [<c0145368>] (device_add+0x394/0x5ac)
[  183.330947] [<c0145368>] (device_add+0x394/0x5ac) from [<bf00cb6c>] (soc_camera_host_register+0x1a4/0x1ec [soc_camera])
[  183.337997] [<bf00cb6c>] (soc_camera_host_register+0x1a4/0x1ec [soc_camera]) from [<bf01dc0c>] (pxa_camera_probe+0x2e4/0x42c [pxa_camera])
[  183.345142] [<bf01dc0c>] (pxa_camera_probe+0x2e4/0x42c [pxa_camera]) from [<c014858c>] (platform_drv_probe+0x1c/0x24)
[  183.352164] [<c014858c>] (platform_drv_probe+0x1c/0x24) from [<c014777c>] (driver_probe_device+0xa4/0x1a8)
[  183.359158] [<c014777c>] (driver_probe_device+0xa4/0x1a8) from [<c0147904>] (__driver_attach+0x84/0x88)
[  183.366088] [<c0147904>] (__driver_attach+0x84/0x88) from [<c0146cd8>] (bus_for_each_dev+0x54/0x80)
[  183.372983] [<c0146cd8>] (bus_for_each_dev+0x54/0x80) from [<c01472c8>] (bus_add_driver+0xa4/0x218)
[  183.379873] [<c01472c8>] (bus_add_driver+0xa4/0x218) from [<c0147b10>] (driver_register+0x58/0x138)
[  183.386766] [<c0147b10>] (driver_register+0x58/0x138) from [<c002128c>] (do_one_initcall+0x2c/0x180)
[  183.393705] [<c002128c>] (do_one_initcall+0x2c/0x180) from [<c0057514>] (sys_init_module+0x88/0x198)
[  183.400650] [<c0057514>] (sys_init_module+0x88/0x198) from [<c0021de0>] (ret_fast_syscall+0x0/0x2c)
[  183.407554] Code: e3a03000 e1c53cb8 e2426020 e3510000 (e5968068)
[  183.411614] ---[ end trace b5c2161a92c2cf9d ]---

Cheers.

--
Robert
