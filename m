Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.179])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tutuyu@usc.edu>) id 1LL0uB-0004Wv-5u
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 20:50:59 +0100
Received: by ik-out-1112.google.com with SMTP id c28so2298611ika.1
	for <linux-dvb@linuxtv.org>; Thu, 08 Jan 2009 11:50:54 -0800 (PST)
Message-ID: <cae4ceb0901081150m24dbfe5dv386236c9144e952d@mail.gmail.com>
Date: Thu, 8 Jan 2009 11:50:53 -0800
From: "Tu-Tu Yu" <tutuyu@usc.edu>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] CX23885 is broken!?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I updated the v4l-dvb this morning, and I tried to load cx23885 by
"modprobe cx23885"
It says
"FATAL: Error inserting cx23885
(/lib/modules/2.6.26-rs/kernel/drivers/media/video/cx23885/cx23885.ko):
Unknown symbol in module, or unknown parameter (see dmesg)"

This is dmesg"==>
cx23885: disagrees about version of symbol video_ioctl2
cx23885: Unknown symbol video_ioctl2
cx23885: disagrees about version of symbol videobuf_dvb_alloc_frontend
cx23885: Unknown symbol videobuf_dvb_alloc_frontend
cx23885: disagrees about version of symbol video_devdata
cx23885: Unknown symbol video_devdata
cx23885: disagrees about version of symbol videobuf_dvb_get_frontend
cx23885: Unknown symbol videobuf_dvb_get_frontend
cx23885: disagrees about version of symbol video_unregister_device
cx23885: Unknown symbol video_unregister_device
cx23885: disagrees about version of symbol video_device_alloc
cx23885: Unknown symbol video_device_alloc
cx23885: disagrees about version of symbol video_register_device
cx23885: Unknown symbol video_register_device
cx23885: disagrees about version of symbol v4l2_chip_match_host
cx23885: Unknown symbol v4l2_chip_match_host
cx23885: disagrees about version of symbol video_device_release
cx23885: Unknown symbol video_device_release

Can anyone help me....? thank you so much!!!!!
Audrey~

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
