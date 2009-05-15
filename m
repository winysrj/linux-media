Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:51957 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbZEONgf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 09:36:35 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M4xaU-0007cO-Qt
	for linux-media@vger.kernel.org; Fri, 15 May 2009 13:36:35 +0000
Received: from ANancy-155-1-46-215.w90-13.abo.wanadoo.fr ([90.13.197.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:36:34 +0000
Received: from Kowaio by ANancy-155-1-46-215.w90-13.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:36:34 +0000
To: linux-media@vger.kernel.org
From: Guillaume <Kowaio@gmail.com>
Subject: Re: V4L2 - Capturing uncompressed data
Date: Fri, 15 May 2009 13:36:23 +0000 (UTC)
Message-ID: <loom.20090515T132629-938@post.gmane.org>
References: <loom.20090515T125828-924@post.gmane.org> <200905151520.26540.laurent.pinchart@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart <laurent.pinchart <at> skynet.be> writes:


> It depends on the camera. If the camera can deliver uncompressed data, you 
> should be able to get that out of the driver. Otherwise you're stuck.
> 
> [snip]
> 

Ok, it's what I was afraid of. 


> That probably means that the camera can't deliver uncompressed data, although 
> you should ask the driver's author to make sure. If the camera indeed supports 
> (M)JPEG only, you will probably have to get another camera.
> 

I'll tell that to my internship supervisor and I'll be back at you if I have
more questions.


> This is the right place for such questions, don't worry.
> 
> Best regards,
> 
> Laurent Pinchart
> 

Thank you for the cordial welcome, I didn't know how mailing lists worked.

Have a good day !

Guillaume.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




