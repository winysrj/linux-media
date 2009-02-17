Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1HIaKqD029777
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 13:36:20 -0500
Received: from web32108.mail.mud.yahoo.com (web32108.mail.mud.yahoo.com
	[68.142.207.122])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1HIa1PR024466
	for <video4linux-list@redhat.com>; Tue, 17 Feb 2009 13:36:01 -0500
Date: Tue, 17 Feb 2009 10:36:01 -0800 (PST)
From: Agustin <gatoguan-os@yahoo.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <50561.11594.qm@web32108.mail.mud.yahoo.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux list <video4linux-list@redhat.com>,
	Linux Arm Kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Rv: mx3-camera on current mxc kernel tree
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

Hi Guennadi,

I am trying to integrate your "mx3_camera" (soc-camera) driver into latest MXC kernel tree in order to be able to use it along with other drivers I need (specially USB and SDHC storage).

I am using branch "mxc-devel" from git://git.pengutronix.de/git/imx/linux-2.6

I am trying to use your patches from http://gross-embedded.homelinux.org/~lyakh/i.MX31-20090124/:
  0001-plat-mxc-define-CONSISTENT_DMA_SIZE-to-8M-needed.patch
  0002-soc-camera-camera-host-driver-for-i.MX3x-SoCs.patch
  0003-soc-camera-board-bindings-for-camera-host-driver-fo.patch
... as apparently everything needed is already present on that branch, since you submitted your latest IPU & IDAC DMA patches to the Linux ARM kernel list.

However, this mx3_camera implementation does not fit the IPU/IDMA API present in the aforementioned tree, and before asuming the required rewritting effort I must ask:

Am I using the right tree, branch and patches for the task?
&
Are you already working on this?


Thanks & regards,
--Agustín.
--
Agustin Ferrin Pozuelo
Embedded Systems Consultant
http://embedded.ferrin.org/
Tel. +34 610502587

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
