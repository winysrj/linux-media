Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63397 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2DQVSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 17:18:48 -0400
Received: by iagz16 with SMTP id z16so9448707iag.19
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2012 14:18:47 -0700 (PDT)
From: Britney Fransen <britney.fransen@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: v4l-cx23885-enc.fw
Date: Tue, 17 Apr 2012 16:18:45 -0500
Message-Id: <59883F72-DC46-4AB7-9271-C0A844A7D45F@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Mime-Version: 1.0 (Apple Message framework v1257)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am not sure where to report this so if this is the wrong place and someone can point me in the right direction it would be appreciated.

http://www.linuxtv.org/downloads/firmware/v4l-cx23885-enc.fw & http://www.linuxtv.org/downloads/firmware/v4l-cx23885-avcore-01.fw look to be the same file with different names.  However when I extract the firmware from http://steventoth.net/linux/hvr1800/ v4l-cx23885-enc.fw is significantly larger than v4l-cx23885-avcore-01.fw.  When using http://www.linuxtv.org/downloads/firmware/v4l-cx23885-enc.fw I get cx23885_initialize_codec() f/w load failed.  Using the larger v4l-cx23885-enc.fw from http://steventoth.net/linux/hvr1800/ the firmware loads without error.  I believe that the http://www.linuxtv.org/downloads/firmware/v4l-cx23885-enc.fw is incorrect.  http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=tree also has the same incorrect v4l-cx23885-enc.fw file.

Thanks,
Britney