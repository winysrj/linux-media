Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:51054 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750895AbdENEbd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 May 2017 00:31:33 -0400
Subject: Re: [RFC] [PATCH 0/4] [media] pxa_camera: Fixing bugs and missing
 colorformats
To: Robert Jarzmik <robert.jarzmik@free.fr>
References: <19820fae-fae3-9579-8f37-5b515e0edb66@tul.cz>
 <34b6ce27-7567-a654-4276-ae522b44f781@tul.cz> <87o9vbz4pp.fsf@belgarion.home>
 <c2c51214-71ad-7c32-5d19-63e731852781@tul.cz>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <be13b205-2d60-b00a-06ec-5008cc635bed@tul.cz>
Date: Sun, 14 May 2017 06:33:16 +0200
MIME-Version: 1.0
In-Reply-To: <c2c51214-71ad-7c32-5d19-63e731852781@tul.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 13.5.2017 v 08:40 Petr Cvek napsal(a):

> The second problem seems to be a same problem. When playing/encoding the data from the sensor (with or without previous fix) and calling (probably) anything on v4l2 the drivers stops in a same way. I discovered it by trying to use the CONFIG_VIDEO_ADV_DEBUG interface to realtime poking the sensor.
> 
> You should be able to recreate that by starting the stream (mplayer or ffmpeg) and run:
> 	v4l2-ctl -n
> or reading registers, running v4l2-compliance etc... 
> 

I get it now. The second problem is likely in pxac_fops_camera_release(). At the closing of the device the function calls sensor_call → s_power and sets the sensor to OFF regardless if somebody is using it somewhere else. There should be reference counter (as was in the original soc_camera_close() function).

This bug makes impossible to debug pxa camera and its sensors.

cheers,
Petr
