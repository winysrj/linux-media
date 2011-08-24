Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39457 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab1HXT0P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 15:26:15 -0400
Received: by wyg24 with SMTP id 24so1103164wyg.19
        for <linux-media@vger.kernel.org>; Wed, 24 Aug 2011 12:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110819113218.05e9cc34@tele>
References: <CA+y5ggjdGZsBSs7UOEpRnoOZh0C96_GOcnvNzmUNAcPo_LF0Lw@mail.gmail.com>
 <20110819113218.05e9cc34@tele>
From: Damien Cassou <damien.cassou@gmail.com>
Date: Wed, 24 Aug 2011 21:25:38 +0200
Message-ID: <CA+y5ggiy8mO1HGaMK9t3PHJXFcPTcoPi0kfucS1OtiZQJAzXVA@mail.gmail.com>
Subject: Re: Image and webcam freeze on Ubuntu with Logitech QuickCam
 Communicate STX
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 19, 2011 at 11:32 AM, Jean-Francois Moine <moinejf@free.fr> wrote:
> I need more information.

Sorry for the delay. Here are the information:

Aug 24 21:21:05 ancizan kernel: [48546.488081] usb 3-1: new full speed
USB device using ohci_hcd and address 3
Aug 24 21:21:05 ancizan kernel: [48546.695280] gspca: probing 046d:08ad
Aug 24 21:21:06 ancizan kernel: [48548.039122] zc3xx: probe 2wr ov vga 0x0000
Aug 24 21:21:06 ancizan kernel: [48548.104109] zc3xx: probe sensor -> 0011
Aug 24 21:21:06 ancizan kernel: [48548.104116] zc3xx: Find Sensor HV7131R
Aug 24 21:21:06 ancizan kernel: [48548.110317] input: zc3xx as
/devices/pci0000:00/0000:00:02.0/usb3/3-1/input/input6
Aug 24 21:21:06 ancizan kernel: [48548.110565] gspca: video0 created
Aug 24 21:21:06 ancizan kernel: [48548.110573] gspca: found int in
endpoint: 0x82, buffer_len=8, interval=10
Aug 24 21:21:06 ancizan kernel: [48548.129182] gspca: [v4l_id] open
Aug 24 21:21:06 ancizan kernel: [48548.129266] gspca: [v4l_id] close
Aug 24 21:21:06 ancizan kernel: [48548.129271] gspca: close done
Aug 24 21:21:06 ancizan kernel: [48548.195903] gspca: [GoogleTalkPlugi] open
Aug 24 21:21:06 ancizan kernel: [48548.195924] gspca: [GoogleTalkPlugi] close
Aug 24 21:21:06 ancizan kernel: [48548.195929] gspca: close done
Aug 24 21:21:06 ancizan kernel: [48548.206901] gspca: [GoogleTalkPlugi] open
Aug 24 21:21:06 ancizan kernel: [48548.206910] gspca: [GoogleTalkPlugi] close
Aug 24 21:21:06 ancizan kernel: [48548.206912] gspca: close done
Aug 24 21:21:06 ancizan kernel: [48548.277014] gspca: [GoogleTalkPlugi] open
Aug 24 21:21:06 ancizan kernel: [48548.277035] gspca: [GoogleTalkPlugi] close
Aug 24 21:21:06 ancizan kernel: [48548.277041] gspca: close done
Aug 24 21:21:07 ancizan rtkit-daemon[1470]: Successfully made thread
6289 of process 1668 (n/a) owned by '1000' RT at priority 5.
Aug 24 21:21:07 ancizan rtkit-daemon[1470]: Supervising 4 threads of 1
processes of 1 users.
Aug 24 21:21:17 ancizan kernel: [48559.302292] gspca: [GoogleTalkPlugi] open
Aug 24 21:21:17 ancizan kernel: [48559.302328] gspca: [GoogleTalkPlugi] close
Aug 24 21:21:17 ancizan kernel: [48559.302333] gspca: close done
Aug 24 21:21:17 ancizan kernel: [48559.308050] gspca: [GoogleTalkPlugi] open
Aug 24 21:21:17 ancizan kernel: [48559.308243] gspca: [GoogleTalkPlugi] close
Aug 24 21:21:17 ancizan kernel: [48559.308249] gspca: close done
Aug 24 21:21:17 ancizan kernel: [48559.308554] gspca: [GoogleTalkPlugi] open
Aug 24 21:21:17 ancizan kernel: [48559.308583] gspca: [GoogleTalkPlugi] close
Aug 24 21:21:17 ancizan kernel: [48559.308587] gspca: close done
Aug 24 21:21:17 ancizan kernel: [48559.342339] gspca: [GoogleTalkPlugi] open
Aug 24 21:21:17 ancizan kernel: [48559.342348] gspca: try fmt cap JPEG 640x480
Aug 24 21:21:17 ancizan kernel: [48559.342387] gspca: frame alloc frsz: 115790
Aug 24 21:21:17 ancizan kernel: [48559.342429] gspca: reqbufs st:0 c:4
Aug 24 21:21:17 ancizan kernel: [48559.342470] gspca: mmap
start:013dd000 size:118784
Aug 24 21:21:17 ancizan kernel: [48559.342487] gspca: mmap
start:013fa000 size:118784
Aug 24 21:21:17 ancizan kernel: [48559.342498] gspca: mmap
start:01417000 size:118784
Aug 24 21:21:17 ancizan kernel: [48559.342508] gspca: mmap
start:01434000 size:118784
Aug 24 21:21:17 ancizan kernel: [48559.343115] gspca: use alt 7 ep 0x81
Aug 24 21:21:17 ancizan kernel: [48559.345174] gspca: init transfer alt 7
Aug 24 21:21:17 ancizan kernel: [48559.345178] gspca: isoc 32 pkts
size 1023 = bsize:32736
Aug 24 21:21:19 ancizan kernel: [48560.684113] zc3xx: probe 2wr ov vga 0x0000
Aug 24 21:21:20 ancizan kernel: [48562.103153] gspca: found int in
endpoint: 0x82, buffer_len=8, interval=10
Aug 24 21:21:20 ancizan kernel: [48562.103162] gspca: stream on OK JPEG 640x480
Aug 24 21:22:43 ancizan kernel: [48645.311117] gspca: ISOC data error:
[0] len=0, status=-18

Hope this helps

Best regards,

-- 
Damien Cassou
http://damiencassou.seasidehosting.st

"Lambdas are relegated to relative obscurity until Java makes them
popular by not having them." James Iry
