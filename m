Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:44535 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752435AbZDVRPl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Apr 2009 13:15:41 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH/RFC v1] soc-camera: (partially) convert to v4l2-(sub)dev API
References: <Pine.LNX.4.64.0904211102400.6551@axis700.grange>
	<Pine.LNX.4.64.0904211215290.6551@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Wed, 22 Apr 2009 19:15:28 +0200
In-Reply-To: <Pine.LNX.4.64.0904211215290.6551@axis700.grange> (Guennadi Liakhovetski's message of "Tue\, 21 Apr 2009 12\:19\:43 +0200 \(CEST\)")
Message-ID: <873ac0pq33.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> ...as promised, my current stack is at 
> http://download.open-technology.de/20090421/. To encourage you to test it 
> now without waiting for my rebase - the functionality shall be exactly the 
> same after the rebase, it really shouldn't change much, or so I hope at 
> least...

Heuh, well I won't be very merry on that one. It seems the first stack I saw a
while ago is back. Maybe a forgotten patch or something ?

[ 1865.359938] [<c0158be8>] (dev_driver_string+0x0/0x48) from [<bf01ccdc>] (pxa_camera_probe+0x2d0/0x41c [pxa_camera])
[ 1865.367855] [<bf01ca0c>] (pxa_camera_probe+0x0/0x41c [pxa_camera]) from [<c015d3f0>] (platform_drv_probe+0x20/0x24)
[ 1865.375776] [<c015d3d0>] (platform_drv_probe+0x0/0x24) from [<c015c44c>] (driver_probe_device+0x88/0x188)
[ 1865.383638] [<c015c3c4>] (driver_probe_device+0x0/0x188) from [<c015c5dc>] (__driver_attach+0x90/0x94)
[ 1865.391472]  r7:c015c54c r6:bf01f494 r5:c02f6bfc r4:c02f6bc8
[ 1865.395448] [<c015c54c>] (__driver_attach+0x0/0x94) from [<c015b95c>] (bus_for_each_dev+0x5c/0x88)
[ 1865.403200]  r6:bf01f494 r5:c04efe50 r4:00000000
[ 1865.407058] [<c015b900>] (bus_for_each_dev+0x0/0x88) from [<c015c2c8>] (driver_attach+0x20/0x28)
[ 1865.414696]  r7:c0589320 r6:bf01f494 r5:bf01f510 r4:00000000
[ 1865.418554] [<c015c2a8>] (driver_attach+0x0/0x28) from [<c015bf74>] (bus_add_driver+0xac/0x220)
[ 1865.426118] [<c015bec8>] (bus_add_driver+0x0/0x220) from [<c015c85c>] (driver_register+0x64/0x148)
[ 1865.433671]  r8:bf01e064 r7:00000000 r6:bf01f494 r5:bf01f510 r4:0002400f
[ 1865.437530] [<c015c7f8>] (driver_register+0x0/0x148) from [<c015d898>] (platform_driver_register+0x6c/0x88)
[ 1865.445045]  r8:bf01e064 r7:00000000 r6:c04ee000 r5:bf01f510 r4:0002400f
[ 1865.448875] [<c015d82c>] (platform_driver_register+0x0/0x88) from [<bf01e078>] (pxa_camera_init+0x14/0x1c [pxa_camera])
[ 1865.456380] [<bf01e064>] (pxa_camera_init+0x0/0x1c [pxa_camera]) from [<c0022294>] (do_one_initcall+0x34/0x188)
[ 1865.463876] [<c0022260>] (do_one_initcall+0x0/0x188) from [<c005d7f4>] (sys_init_module+0x90/0x1a0)
[ 1865.471331] [<c005d764>] (sys_init_module+0x0/0x1a0) from [<c0022e40>] (ret_fast_syscall+0x0/0x2c)
[ 1865.478727]  r7:00000080 r6:00000003 r5:0002400f r4:00000000

Cheers.

--
Robert
