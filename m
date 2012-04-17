Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:50291 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab2DQUpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 16:45:51 -0400
Received: from basile.localnet (ip6-localhost [IPv6:::1])
	by oyp.chewa.net (Postfix) with ESMTP id 4CC8D2019A
	for <linux-media@vger.kernel.org>; Tue, 17 Apr 2012 22:45:37 +0200 (CEST)
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: v4l2 Device with H264 support
Date: Tue, 17 Apr 2012 23:45:47 +0300
References: <alpine.DEB.2.02.1204171159380.3685@eragon.insync.za.net> <a5a29db4793a36095a2f8746361f6b63@chewa.net> <alpine.DEB.2.02.1204180828510.3685@eragon.insync.za.net>
In-Reply-To: <alpine.DEB.2.02.1204180828510.3685@eragon.insync.za.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204172345.47837.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 17 avril 2012 23:30:43 Pieter De Wit, vous avez écrit :
> Thanks for the reply. I suspect that there is some tricks needed to get
> the h264 stream from this device, into something of a player.

At least for UVC devices, it's pretty damn straight forward. You just need to 
set pixel format 'H264' with the standard VIDIOC_S_FMT. Then you get the H.264 
elementary stream with the plain normal streaming or read/write modes of V4L2.

E.g.:

# v4l2-ctl --set-fmt-video=width=640,height=480,pixelformat=H264
# vlc v4l2c/h264://

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
