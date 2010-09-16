Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o8G9XJiN012203
	for <video4linux-list@redhat.com>; Thu, 16 Sep 2010 05:33:20 -0400
Received: from mail-vw0-f46.google.com (mail-vw0-f46.google.com
	[209.85.212.46])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8G9X7tl014864
	for <video4linux-list@redhat.com>; Thu, 16 Sep 2010 05:33:07 -0400
Received: by vws3 with SMTP id 3so1104456vws.33
	for <video4linux-list@redhat.com>; Thu, 16 Sep 2010 02:33:07 -0700 (PDT)
MIME-Version: 1.0
From: Alexander <berechitai@gmail.com>
Date: Thu, 16 Sep 2010 13:32:46 +0400
Message-ID: <AANLkTikPhn55r5_M2ETXKQv+ipzmG+G5_djhaZ0rmcbv@mail.gmail.com>
Subject: Connexant cx25821 help
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>

I have a PCI-E capture card with two connexant cx25821 chips.
04:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8210
05:00.0 Multimedia video controller: Conexant Systems, Inc. Device 8210


There is a staging driver in latest linux kernels. Looks like it uses v4l2
api.
I tried to use precompiled module cx25821 provided with Ubuntu 10.10 beta
(2.6.35-19-generic #28-Ubuntu SMP Sun Aug 29 06:36:51 UTC 2010 i686
GNU/Linux).

# modprobe cx25821

The module looks like to be loaded successfully.

# lsmod | grep cx
cx25821               108646  0
v4l2_common            17329  1 cx25821
videodev               43098  2 cx25821,v4l2_common
videobuf_dma_sg         9806  1 cx25821
videobuf_core          16907  2 cx25821,videobuf_dma_sg
btcx_risc               3636  1 cx25821
tveeprom               11178  1 cx25821

dmesg says:
[ 1980.986232] Linux video capture interface: v2.00
[ 1980.989245] cx25821: module is from the staging directory, the quality is
unknown, you have been warned.
[ 1980.993152] cx25821 driver version 0.0.106 loaded

And now I can not see any /dev/video0-7 devices to get input from the card.
I'l greatly appreciate if someone could tell me about additional actions to
make this work.
Thank you.
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
