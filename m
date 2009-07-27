Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:8430 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZG0SFB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2009 14:05:01 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1723935qwh.37
        for <linux-media@vger.kernel.org>; Mon, 27 Jul 2009 11:05:01 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Jul 2009 14:05:01 -0400
Message-ID: <de8cad4d0907271105o1ec1b425ocd903434aa39e2f5@mail.gmail.com>
Subject: Warnings in Compile
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings,

I received the following warnings while compiling a fresh pull today
from v4l-dvb.

  CC [M]  /root/drivers/v4l-dvb/v4l/pvrusb2-hdw.o
/root/drivers/v4l-dvb/v4l/pvrusb2-hdw.c: In function 'pvr2_hdw_load_modules':
/root/drivers/v4l-dvb/v4l/pvrusb2-hdw.c:2145: warning: format not a
string literal and no format arguments

  CC [M]  /root/drivers/v4l-dvb/v4l/pvrusb2-std.o
/root/drivers/v4l-dvb/v4l/pvrusb2-std.c: In function 'pvr2_std_id_to_str':
/root/drivers/v4l-dvb/v4l/pvrusb2-std.c:220: warning: format not a
string literal and no format arguments

  CC [M]  /root/drivers/v4l-dvb/v4l/zoran_card.o
/root/drivers/v4l-dvb/v4l/zoran_card.c: In function 'zoran_probe':
/root/drivers/v4l-dvb/v4l/zoran_card.c:1379: warning: format not a
string literal and no format arguments
/root/drivers/v4l-dvb/v4l/zoran_card.c:1391: warning: format not a
string literal and no format arguments

  CC [M]  /root/drivers/v4l-dvb/v4l/v4l2-common.o
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function 'v4l2_i2c_new_subdev':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:835: warning: format not a
string literal and no format arguments
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
'v4l2_i2c_new_probed_subdev':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:908: warning: format not a
string literal and no format arguments
/root/drivers/v4l-dvb/v4l/v4l2-common.c: In function
'v4l2_i2c_new_subdev_board':
/root/drivers/v4l-dvb/v4l/v4l2-common.c:990: warning: format not a
string literal and no format arguments

  CC [M]  /root/drivers/v4l-dvb/v4l/tvaudio.o
/root/drivers/v4l-dvb/v4l/tvaudio.c: In function 'tvaudio_probe':
/root/drivers/v4l-dvb/v4l/tvaudio.c:2075: warning: format not a string
literal and no format arguments

  CC [M]  /root/drivers/v4l-dvb/v4l/cx2341x.o
/root/drivers/v4l-dvb/v4l/cx2341x.c: In function 'cx2341x_ctrl_query_fill':
/root/drivers/v4l-dvb/v4l/cx2341x.c:494: warning: format not a string
literal and no format arguments

This is running Ubuntu 9.0.4: Linux 2.6.28-11-server #42-Ubuntu SMP
Fri Apr 17 02:45:36 UTC 2009 x86_64 GNU/Linux

HIH,

Brandon
