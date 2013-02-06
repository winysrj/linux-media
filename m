Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57475 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572Ab3BFPOQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Feb 2013 10:14:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1U36hk-0008Bm-RL
	for linux-media@vger.kernel.org; Wed, 06 Feb 2013 16:14:32 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 16:14:32 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 16:14:32 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: Replacement for vloopback?
Date: Wed, 06 Feb 2013 16:14:05 +0100
Message-ID: <ketrvq$r21$1@ger.gmane.org>
References: <ketngk$dit$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
In-Reply-To: <ketngk$dit$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks everybody so far.

I just found v4l2loopback and also some examples with gestreamer.

I will do some testing and see if I can get my use case done with that.

Kind regards

Michael

Am 06.02.2013 14:57, schrieb Neuer User:
> Hello
> 
> I need to have access to my webcam from two applications (one is
> "motion", the other a video sip phone).
> 
> I have googled a lot, but only found vloopback as a method to access a
> video device from two applications. However, vloopback seems to rely on
> V4L1 which is mostly no longer compiled into the kernel by most distros.
> Additionally, it does not seem to compile against newer kernels.
> 
> So, my question ist: Is vloopback the right way to go for this
> requirement? If yes, how to get it working?
> 
> If not, what can I use to have two apps accessing the video stream from
> the webcam?
> 
> Thanks a lot for any help
> 
> Michael
> 


