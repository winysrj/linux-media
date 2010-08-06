Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:20174 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759313Ab0HFMWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Aug 2010 08:22:44 -0400
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: Andy Walls <awalls@md.metrocast.net>
To: lawrence rust <lawrence@softsystem.co.uk>
Cc: Shane Harrison <shane.harrison@paragon.co.nz>,
	linux-media@vger.kernel.org
In-Reply-To: <1281087650.1332.26.camel@gagarin>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	 <1280741544.1361.17.camel@gagarin>
	 <AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	 <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
	 <1280750394.1361.87.camel@gagarin>
	 <AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
	 <1280843299.1492.127.camel@gagarin>
	 <AANLkTik0UZmf5b4nTi1AgFiKQAGkvU47_dN0gUSw3urs@mail.gmail.com>
	 <1281087650.1332.26.camel@gagarin>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 08:22:19 -0400
Message-ID: <1281097339.2052.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-08-06 at 11:40 +0200, lawrence rust wrote:
> On Fri, 2010-08-06 at 11:49 +1200, Shane Harrison wrote:

> > Well still no luck this end.  Have done the following:

> > 2) Applied the patch - no change (we were detecting the WM8775 OK

BTW, I forgot to mention the ivtv driver uses the WM8775 module for the
PVR-150 card.  Changes to that module that affect the default setting
needs to be done in a way that doesn't break the PVR-150.

Maybe a .s_config() method in the WM8775 v4l2_subdev_core_ops would be
the way to do that, or by passing parameters in struct i2c_board_info
(according to a recent post by Hans Verkuil).

Regards,
Andy

