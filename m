Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:52765 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZERGy2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 02:54:28 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M5wjy-00067a-UV
	for linux-media@vger.kernel.org; Mon, 18 May 2009 06:54:27 +0000
Received: from ANancy-155-1-46-215.w90-13.abo.wanadoo.fr ([90.13.197.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 06:54:26 +0000
Received: from Kowaio by ANancy-155-1-46-215.w90-13.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 06:54:26 +0000
To: linux-media@vger.kernel.org
From: Guillaume <Kowaio@gmail.com>
Subject: Re: V4L2 - Capturing uncompressed data
Date: Mon, 18 May 2009 06:54:13 +0000 (UTC)
Message-ID: <loom.20090518T065037-781@post.gmane.org>
References: <loom.20090515T125828-924@post.gmane.org> <200905151520.26540.laurent.pinchart@skynet.be> <Pine.LNX.4.64.0905152101380.4658@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > It depends on the camera.
> 
> ...and the driver. I don't know much about various _web_cameras and their 
> drivers, but I could well imagine, that you're asking for an unsupported 
> YUV variation, whereas some other format would be supported. Why don't you 
> use VIDIOC_ENUM_FMT to list all supported formats? Or even look in the 
> driver source - it's open
> 


Hi,
Thanks for your answer. I didn't try ENUM_FMT but I tried to set every available
format of V4L2 (that we can found in the "videodev2.h"), but the only one
possible is the compressed JPEG Format.

You said to look in the driver source, but where exactly do I have to look for ?

Thank you for your time,

Regards,
Guillaume.



