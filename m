Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dmlb2000@gmail.com>) id 1JVz7h-0002yX-Tj
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 02:05:46 +0100
Received: by el-out-1112.google.com with SMTP id o28so2449375ele.2
	for <linux-dvb@linuxtv.org>; Sun, 02 Mar 2008 17:05:41 -0800 (PST)
Message-ID: <9c21eeae0803021705g13913d49m796e3398682fdee1@mail.gmail.com>
Date: Sun, 2 Mar 2008 17:05:41 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>
In-Reply-To: <47C82112.3080404@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <9c21eeae0802282219r4280de1ex6d47a5be2759fb52@mail.gmail.com>
	<47C82112.3080404@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx23885 status?
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

>  All patches welcome, just submit them to this list.

Okay here's a patch... got rid of the dmesg output I was having...

diff -r 85708d2698cd linux/drivers/media/video/cx23885/cx23885-video.c
--- a/linux/drivers/media/video/cx23885/cx23885-video.c Tue Jan 22
22:22:08 2008 -0500
+++ b/linux/drivers/media/video/cx23885/cx23885-video.c Sun Mar 02
16:59:34 2008 -0800
@@ -160,6 +160,14 @@ static struct cx23885_fmt formats[] = {
                        ColorFormatWSWAP,
 #endif
                .depth    = 32,
+               .flags    = FORMAT_FLAGS_PACKED,
+       }, {
+               .name     = "4:2:0, packed, YV12",
+               .fourcc   = V4L2_PIX_FMT_YVU420,
+#if 0
+               .cxformat = ColorFormatYUY2,
+#endif
+               .depth    = 12,
                .flags    = FORMAT_FLAGS_PACKED,
        }, {
                .name     = "4:2:2, packed, YUYV",

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
