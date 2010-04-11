Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp103.plus.mail.re1.yahoo.com ([69.147.102.66]:23978 "HELO
	smtp103.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753995Ab0DIILQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Apr 2010 04:11:16 -0400
Message-ID: <4BC18320.70604@yahoo.gr>
Date: Sun, 11 Apr 2010 11:06:56 +0300
From: Nick GIannakopoulos <int_nick_dot@yahoo.gr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: em28xx: board id  [eb1a:e310]
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hi, 

 I've made tests with my *KWORLD DVB USB 2.0 310U* board:

 *Model*: KWORLD DVB USB 2.0 310U
 *Vendor/Product id*: [eb1a:e310]
 *Kernel:* 2.6.33 + v4l-dvb-fw-bf7cd2fb7a35 + xc3028-v27.fw

 *Tests made*: 

     - Analog [Worked Video+Audio, But i can change channels correctly only if i set manually frequencies to mplayer freq=]
     - DVB    [No]
     - VBI    [ Seems to work ]

* Part of Kernel Logs:*
  
 --------------->
 [ 2268.140148] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 0, class 0)
 [ 2268.141492] em28xx #0: chip ID is em2882/em2883
  ...

 [ 2269.439708] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
  ...

 [ 2271.510368] em28xx #0: /2: dvb frontend not attached. Can't attach xc3028
 [ 2271.510373] Em28xx: Initialized (Em28xx dvb Extension) extension
 ---------------->

 More tests i will post soon.
 If you need more informations/logs about this board let me know. 

 *Tested-by*: int_nick_dot@yahoo.gr



