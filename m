Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4DKKJo7025711
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 16:20:19 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4DKJo3s022771
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 16:19:50 -0400
Date: Tue, 13 May 2008 22:19:46 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Darius <augulis.darius@gmail.com>
In-Reply-To: <g0bjtj$b0d$1@ger.gmane.org>
Message-ID: <Pine.LNX.4.64.0805132212530.4988@axis700.grange>
References: <g09j17$3m9$1@ger.gmane.org>
	<Pine.LNX.4.64.0805122030310.5526@axis700.grange>
	<g0bjtj$b0d$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: question about SoC Camera driver (Micron)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Tue, 13 May 2008, Darius wrote:

> Now I see how it works. I2C devices should be created before driver loading.
> There was my mistake, and driver does not call probe() function. Maybe would
> be better to create I2C devices by driver itself, not by the board specific
> config code? Now sensor driver is useless itself, without board specific
> configuration... Would be correct to do so?

No. This is not how the driver model works. PCI drivers do not register 
PCI devices. The PCI host controller scans the PCI bus and adds devices 
into the system, to be later matched against PCI drivers. Similar for USB 
devices, etc. The problem with i2c you cannot reliably scan the bus. 
Therefore the information about devices present on the system has to come 
from elsewhere: when it is an i2c device embedded into a USB web-camera, 
its driver "knows", there's an i2c device and registers it. On embedded 
systems the platform knows what i2c devices are onboard, and registers 
them using i2c_register_board_info(), on powerpc (and sparc?) you can 
register i2c devices in your device tree, etc.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
