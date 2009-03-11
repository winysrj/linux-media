Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.atmel.fr ([81.80.104.162]:57845 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZCKJxG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 05:53:06 -0400
Message-ID: <49B789F8.3070906@atmel.com>
Date: Wed, 11 Mar 2009 10:52:56 +0100
From: Sedji Gaouaou <sedji.gaouaou@atmel.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: atmel v4l2 soc driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am currently porting an atmel isi driver to the soc layer, and I 
encounter some problems.
I have based my driver on pax-camera. and sh_mobile_ceu_camera.c.
The point is I can't see any video entry in /dev when I do ls dev/ on my 
board...
So I wonder when is soc_camera_video_start(which call 
video_register_device) called? Is that at the probe?

Regards,
Sedji

