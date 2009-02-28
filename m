Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:38725 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZB1Tb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Feb 2009 14:31:56 -0500
Received: by ti-out-0910.google.com with SMTP id d10so2262769tib.23
        for <linux-media@vger.kernel.org>; Sat, 28 Feb 2009 11:31:53 -0800 (PST)
Message-ID: <49A99124.6090402@gmail.com>
Date: Sun, 01 Mar 2009 08:31:48 +1300
From: vivian stewart <vivichrist@gmail.com>
Reply-To: vivichrist@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: HVR3000 v4l no longer compiles with any branch and/or patch in 64bitOS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I get this error when compiling v4l-dvb 7285 and 7879 (can't find patch 
via the links, their in the tmp directory?) under ubuntu hardy 
2.6.24-23-rt amd64:

/home/vivy/v4l-dvb/v4l/saa7134-video.c: In function 'saa7134_s_fmt_overlay':
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1674: error: size of array 'type 
name' is negative
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1674: warning: comparison of 
distinct pointer types lacks a cast
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1677: error: size of array 'type 
name' is negative
/home/vivy/v4l-dvb/v4l/saa7134-video.c:1677: warning: comparison of 
distinct pointer types lacks a cast
make[3]: *** [/home/vivy/v4l-dvb/v4l/saa7134-video.o] Error 1
make[2]: *** [_module_/home/vivy/v4l-dvb/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.24-23-rt'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/vivy/v4l-dvb/v4l'
make: *** [all] Error 2

which compiled and worked before I had to reinstall (from 32bit to 
64bit)ubuntu from scratch. think I mite be missing some installed source 
code somewhere or is not amd64 compatible code.
as for 8894 I think I remember it compiling but just no dvb-s even 
though its mfe. dvb-s is really what I want
