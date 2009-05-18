Return-path: <linux-media-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53302 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbZERHdH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 03:33:07 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1M5xLO-0007hT-Vv
	for linux-media@vger.kernel.org; Mon, 18 May 2009 07:33:07 +0000
Received: from ANancy-155-1-46-215.w90-13.abo.wanadoo.fr ([90.13.197.215])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 07:33:06 +0000
Received: from Kowaio by ANancy-155-1-46-215.w90-13.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 07:33:06 +0000
To: linux-media@vger.kernel.org
From: Guillaume <Kowaio@gmail.com>
Subject: Re: V4L2 - Capturing uncompressed data
Date: Mon, 18 May 2009 07:32:53 +0000 (UTC)
Message-ID: <loom.20090518T072801-624@post.gmane.org>
References: <loom.20090515T125828-924@post.gmane.org> <200905151520.26540.laurent.pinchart@skynet.be> <Pine.LNX.4.64.0905152101380.4658@axis700.grange> <loom.20090518T065037-781@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guillaume <Kowaio <at> gmail.com> writes:


I just tried the ENUM_FMT, and there is only 1 format, 
the JPEG one.

But I don't understand one thing. The webcam displays 
compressed Jpeg data. OK.
But before that compression, the data aren't in 
uncompressed data ? 
It's the driver or something which is doing that 
compression directly during the capture, but there 
really are no chance to get that uncompressed 
data before compression in JPEG ?

