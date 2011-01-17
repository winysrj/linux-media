Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:62945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1AQQ17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 11:27:59 -0500
Date: Mon, 17 Jan 2011 17:27:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Markus Niebel <list-09_linux_media@tqsc.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mx3_camera and DMA / double buffering
In-Reply-To: <4D34617D.9090301@tqsc.de>
Message-ID: <Pine.LNX.4.64.1101171724360.16051@axis700.grange>
References: <4CF7AE4A.7070107@tqsc.de> <Pine.LNX.4.64.1012022103270.26762@axis700.grange>
 <4CF91228.3030709@tqsc.de> <Pine.LNX.4.64.1012032105200.5693@axis700.grange>
 <4D34617D.9090301@tqsc.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 17 Jan 2011, Markus Niebel wrote:

> Hello,
> 
> sorry for the __very__ long timeout. The doublebuffering is indeed enabled
> when the second buffer is queued - my fault, should have read the code more
> carfully.

Good.

> But in this way a new question arises:
> 
> in soc_camera.c, function soc_camera_streamon the subdev's s_stream handler is
> called first before videobuf_streamon gets called. This way the videosource is
> producing data which could produce a race condition with the idmac.

Starting the sensor before the host shouldn't cause any problems, because 
hosts should be capable of handling sensors, continuously streaming data. 
So, the order should be ok, if the mx3-camera driver gets problems with 
it, it has a bug and it should be fixed.

> Maybe I'm
> wrong but in some cases (especially whith enabled dev_dbg in ipu_idmac.c) we
> fail to get frames from the driver.

Sorry, what exactly do you mean? Capture doesn't start at all? Or it 
begins and then hangs? Or some fraims get dropped? Please, explain in more 
detail.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
