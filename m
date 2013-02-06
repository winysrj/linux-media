Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41892 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab3BFOnJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Feb 2013 09:43:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1U36Dd-0005G6-Su
	for linux-media@vger.kernel.org; Wed, 06 Feb 2013 15:43:25 +0100
Received: from 84-72-11-174.dclient.hispeed.ch ([84.72.11.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 15:43:25 +0100
Received: from auslands-kv by 84-72-11-174.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2013 15:43:25 +0100
To: linux-media@vger.kernel.org
From: Neuer User <auslands-kv@gmx.de>
Subject: Re: Replacement for vloopback?
Date: Wed, 06 Feb 2013 15:42:54 +0100
Message-ID: <ketq5c$8dc$1@ger.gmane.org>
References: <ketngk$dit$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
In-Reply-To: <ketngk$dit$1@ger.gmane.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for answering.

The vloopback description seems to imply that it is possible to share a
camera stream:

"How to use multiple webcam applications with vloopback

[...]
Do "modprobe vloopback pipes=2". Then "resize /dev/video0 /dev/video1
640x480 640x480 & resize /dev/video2 /dev/video3 640x480 320x240".
(Assuming that you have only one real video device at /dev/video0. You
can check with dmesg).

Now, you can watch your webcam with camstream at 640x480 (choose the
device called vloopback0 output in camstream's menu, which is
/dev/video2), at the sime time you can record a video of your webcam
stream at 320x240 by doing "ffmpeg -vd /dev/video4 -s 320x240
picture.mpeg", you can at the same time run a webcam http server by
running "camsource" (after editting camsource.conf to choose /dev/video2
or /dev/video4 as v4l_input source)."

If it is not possible to have two applications access the same video
stream, that is pretty detrimentical to quite a lot of use cases, e.g.:

a.) Use motion to detect motion and record video. At the same time view
the camera output on the screen.

b.) Stream a webcam output over the net and at the same time view it on
the screen.


Actually, for me it would be no problem, if the stream needs to be the
same format etc.

So, really no way? :-(

Thanks

Michael



> On Wed, 06 Feb 2013 14:57:43 +0100, Neuer User <auslands-kv@gmx.de> wrote:
>> So, my question ist: Is vloopback the right way to go for this
>> requirement? If yes, how to get it working?
> 
> No. Video loopback is just a way for an application to expose a virtual
> camera, for another application to use. It is not a way to share a camera
> within two applications.
> 
> Sharing a camera is fundamentally impossible due to the limitation of the
> hardware, which cannot capture in two different formats and sets of buffers
> simultaneously. Live with it.
> 
> -- Rémi Denis-Courmont Sent from my collocated server 



