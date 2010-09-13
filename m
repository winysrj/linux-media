Return-path: <mchehab@localhost.localdomain>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2256 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0IMHCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 03:02:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc driver
Date: Mon, 13 Sep 2010 09:02:30 +0200
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
References: <201009122226.11970.hverkuil@xs4all.nl> <1284325962.2394.24.camel@localhost>
In-Reply-To: <1284325962.2394.24.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009130902.30242.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Sunday, September 12, 2010 23:12:42 Andy Walls wrote:
> On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:
> 
> > And other news on the V4L1 front:
> 
> > I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
> > support can be removed from that driver as well.
> 
> FYI, that will break this 2005 vintage piece of V4L1 software people may
> still be using for the QX5 microscope:
> 
> http://www.cryptoforge.net/qx5/qx5view/
> http://www.cryptoforge.net/qx5/qx5view/qx5view-0.5.tar.gz

Why? qx5view has support for v4l2 as well.

Regards,

	Hans

> 
> The wiki page happens to mention qx5view:
> http://linuxtv.org/wiki/index.php/QX5_USB_microscope
> 
> 
> Slightly OT: The private V4L2 control for the "Lights" in cpia2_v4l.c
> could be changed to Illuminator [12] for the QX5 microscope.
> 
> Regards,
> Andy
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
