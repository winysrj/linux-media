Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39751 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab1LEEPg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Dec 2011 23:15:36 -0500
Subject: Re: cx231xx kernel oops
From: Andy Walls <awalls@md.metrocast.net>
To: Yan Seiner <yan@seiner.com>
Cc: linux-media@vger.kernel.org
Date: Sun, 04 Dec 2011 23:15:27 -0500
In-Reply-To: <4EDC25F1.4000909@seiner.com>
References: <4EDC25F1.4000909@seiner.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1323058527.12343.3.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2011-12-04 at 18:01 -0800, Yan Seiner wrote:
> I am experiencing a kernel oops when trying to use a Hauppage USB Live 2 
> frame grabber.  The oops is below.
> 
> The system is a SOC 260Mhz Broadcom BCM47XX access point running OpenWRT.
> 
> root@anchor:/# uname -a
> Linux anchor 3.0.3 #13 Sun Dec 4 08:04:41 PST 2011 mips GNU/Linux
> 
> The OOPS could be due to the limited hardware or something else.  I'd 
> appreciate any suggestions for making this work.  I was hoping with 
> hardware compression I could make it work on this platform.  I am 
> currently using a Hauppage USB Live (saa7115 based) with no problems but 
> with limited resolution.
> 
> cx231xx v4l2 driver loaded.
> cx231xx #0: New device Hauppauge Hauppauge Device @ 480 Mbps (2040:c200) with 5 interfaces
> cx231xx #0: registering interface 1
> cx231xx #0: can't change interface 3 alt no. to 3: Max. Pkt size = 0
> cx231xx #0: can't change interface 4 alt no. to 1: Max. Pkt size = 0
> cx231xx #0: Identified as Hauppauge USB Live 2 (card=9)
> cx231xx #0: cx231xx_dif_set_standard: setStandard to ffffffff
> cx231xx #0: Changing the i2c master port to 3
> cx231xx #0: cx25840 subdev registration failure
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The cx231xx driver requires the cx25840 module.  I'll wager you didn't
install it on your router.

Regards,
Andy



