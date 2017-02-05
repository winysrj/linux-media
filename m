Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37929 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdBEDlr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2017 22:41:47 -0500
Received: by mail-it0-f45.google.com with SMTP id c7so37711772itd.1
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2017 19:41:47 -0800 (PST)
Received: from [192.168.2.215] (bras-vprn-mtrlpq0806w-lp140-01-70-26-206-103.dsl.bell.ca. [70.26.206.103])
        by smtp.gmail.com with ESMTPSA id v197sm2249351ita.2.2017.02.04.19.41.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 Feb 2017 19:41:46 -0800 (PST)
Message-ID: <58969EF9.2000703@gmail.com>
Date: Sat, 04 Feb 2017 22:41:45 -0500
From: Bill Atwood <williamatwood41@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Failure of ./build
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am attempting to build the V4L-DVB Device Drivers according to 
https://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

The build stops with a failure message, the last few lines of which are 
shown in the following extract:

No file to patch.  Skipping patch.
1 out of 1 hunk ignored
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory `/home/bill/V4L/media_build/linux'
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory `/home/bill/V4L/media_build/v4l'
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 490.
bill@willow:~/V4L/media_build$

I am running Ubuntu 14.04.1 LTS.  (I recently tried to update to 16.04 
LTS, but it fails for some obscure reason.)  My kernel is 
3.13.0-108-generic.

My capture card is a Hauppauge WinTV HVR 955Q, and it is plugged in. 
The device ID is 2040:b123 Hauppauge.

I understand the basics of using "make" and am well familiar with 
Linux/Ubuntu use, but these messages tell me nothing.  I would be happy 
to upload the entire output from the build, but I am reluctant to put 
all 273 lines in this message.

Can anyone suggest an approach to resolving my problem?

   Bill
