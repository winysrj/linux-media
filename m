Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:64621 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZEZND5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 May 2009 09:03:57 -0400
Received: by bwz22 with SMTP id 22so3778111bwz.37
        for <linux-media@vger.kernel.org>; Tue, 26 May 2009 06:03:58 -0700 (PDT)
Message-ID: <4A1BE8BC.3010901@gmail.com>
Date: Tue, 26 May 2009 15:03:56 +0200
From: Antonio Beamud Montero <antonio.beamud@gmail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: v4l-dvb and old kernels
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It would compile today's snapshot of v4l-dvb with an old kernel version 
(for example 2.6.16)? (or is better to upgrade the kernel?)

Trying to compile today's mercurial snapshot in a SuSE 10.1 (2.6.16-21), 
give the next errors:

/root/v4l-dvb/v4l/bttv-i2c.c: In function 'init_bttv_i2c':
/root/v4l-dvb/v4l/bttv-i2c.c:411: error: storage size of 'info' isn't known
/root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
to incomplete type 'struct i2c_board_info'
/root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
to incomplete type 'struct i2c_board_info'
/root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
to incomplete type 'struct i2c_board_info'
/root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
to incomplete type 'struct i2c_board_info'
/root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
to incomplete type 'struct i2c_board_info'
/root/v4l-dvb/v4l/bttv-i2c.c:425: error: invalid application of 'sizeof' 
to incomplete type 'struct i2c_board_info'
/root/v4l-dvb/v4l/bttv-i2c.c:427: error: implicit declaration of 
function 'i2c_new_probed_device'
/root/v4l-dvb/v4l/bttv-i2c.c:411: warning: unused variable 'info'
make[5]: *** [/root/v4l-dvb/v4l/bttv-i2c.o] Error 1

Greetings.
