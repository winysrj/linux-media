Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:30728 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932503Ab0LTADn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 19:03:43 -0500
Subject: Re: Power frequency detection.
From: Andy Walls <awalls@md.metrocast.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Adam Baker <linux@baker-net.org.uk>,
	Paulo Assis <pj.assis@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1012191814240.24101@banach.math.auburn.edu>
References: <73wo0g3yy30clob2isac30vm.1292782894810@email.android.com>
	 <alpine.LNX.2.00.1012191423030.23950@banach.math.auburn.edu>
	 <201012192332.38060.linux@baker-net.org.uk>
	 <alpine.LNX.2.00.1012191814240.24101@banach.math.auburn.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 19:04:24 -0500
Message-ID: <1292803464.3710.7.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sun, 2010-12-19 at 18:21 -0600, Theodore Kilgore wrote:

> If the controls are locked while the workqueue is doing the streaming, 
> then probably that does fix the problem? Most likely, that is the simplest 
> thing to do. 

Drivers are allowed to return -EBUSY per the V4L2 spec.

http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ctrl.html
http://linuxtv.org/downloads/v4l-dvb-apis/vidioc-g-ext-ctrls.html

Regards,
Andy


> Theodore Kilgore


