Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34814 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbbFSHdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2015 03:33:14 -0400
Received: by pabvl15 with SMTP id vl15so33464454pab.1
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2015 00:33:14 -0700 (PDT)
Received: from [192.168.1.103] (122-60-133-37.jetstream.xtra.co.nz. [122.60.133.37])
        by mx.google.com with ESMTPSA id dv9sm10248959pac.4.2015.06.19.00.33.12
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jun 2015 00:33:13 -0700 (PDT)
Date: Fri, 19 Jun 2015 19:33:08 +1200
From: Michael <mike.bean.heyns@gmail.com>
Subject: Total system hang/freeze - segfault - error 4 in libc-2.21.so
To: linux-media@vger.kernel.org
Message-Id: <1434699188.4547.1@smtp.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Greetings!

Apologies if this is the inappropriate method of contact. I was 
directed here from tvheadend's support forum.

I have an Asrock Q2900-ITX with an RTL2838 USB DVB-T device (0bda:2838) 
that works out of the box on Kernels 3.19.0 (Ubuntu Vivid) and 4.0.5 
(both distros).

Unfortunately, while using the device, either system (my laptop or 
media center) will freeze. No response at all, power-cycle needed.
I downgraded Arch to the 3.14.44 LTS kernel where everything seems 
stable.

There's no log of kernel panicking. The only form of errors I could 
find at all are at the time of the freeze:

 kernel: [   10.330935] show_signal_msg: 39 callbacks suppressed
 kernel: [   10.330946] PVRManager[1212]: segfault at 18 ip 
00007fecdf6fe929 sp 00007feca67fb430 error 4 in 
libc-2.21.so[7fecdf67d000+1c0000]

Maybe this means something to you guys? I am willing to provide more 
information and stuff if you want. This is pretty alien to me.

Thank you!
Michael

