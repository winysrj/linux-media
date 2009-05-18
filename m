Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37351 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZERJ71 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 05:59:27 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M5zd1-0005WO-Hf
	for linux-media@vger.kernel.org; Mon, 18 May 2009 09:59:27 +0000
Received: from ANancy-155-1-81-229.w92-141.abo.wanadoo.fr ([92.141.236.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 09:59:27 +0000
Received: from Kowaio by ANancy-155-1-81-229.w92-141.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 09:59:27 +0000
To: linux-media@vger.kernel.org
From: Guillaume <Kowaio@gmail.com>
Subject: Re: V4L2 - Capturing uncompressed data
Date: Mon, 18 May 2009 09:59:13 +0000 (UTC)
Message-ID: <loom.20090518T094558-189@post.gmane.org>
References: <loom.20090515T125828-924@post.gmane.org> <loom.20090518T065037-781@post.gmane.org> <loom.20090518T072801-624@post.gmane.org> <200905181053.14043.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart <at> skynet.be> writes:


> The video stream is compressed directly by the webcam and sent to the host in 
> compressed form.
> 
> Best regards,
> 
> Laurent Pinchart

I spoke with my supervisor. He'll try to get a camera 
which allow uncompressed format.
In the meantime, and in order to do stop-motion 
in the application, I need to get the best quality possible 
of the webcam in one 'shot' (not video, just picture).
Is there any way to get the value of compression of the jpeg
by the V4L2 in order to do a software extrapolation after.

For instance, with some webcams (1.3 millions pixels), 
you can capture a 640*480 resolution in video mode
but some allow pictures in 800*600 by extrapolation.

So in order to do that extrapolation, I need the value
of compression of the JPEG use by V4L2. Is it always the same,
or it depends on the camera ? And can v4l2 get and modify this value ?


