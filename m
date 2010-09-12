Return-path: <mchehab@localhost.localdomain>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:61362 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753501Ab0ILVLq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 17:11:46 -0400
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove V4L1 support from the pwc
 driver
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <201009122226.11970.hverkuil@xs4all.nl>
References: <201009122226.11970.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 17:12:42 -0400
Message-ID: <1284325962.2394.24.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@localhost.localdomain>

On Sun, 2010-09-12 at 22:26 +0200, Hans Verkuil wrote:

> And other news on the V4L1 front:

> I'm waiting for test results on the cpia2 driver. If it works, then the V4L1
> support can be removed from that driver as well.

FYI, that will break this 2005 vintage piece of V4L1 software people may
still be using for the QX5 microscope:

http://www.cryptoforge.net/qx5/qx5view/
http://www.cryptoforge.net/qx5/qx5view/qx5view-0.5.tar.gz

The wiki page happens to mention qx5view:
http://linuxtv.org/wiki/index.php/QX5_USB_microscope


Slightly OT: The private V4L2 control for the "Lights" in cpia2_v4l.c
could be changed to Illuminator [12] for the QX5 microscope.

Regards,
Andy


