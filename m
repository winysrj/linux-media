Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39224 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab3LaAtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 19:49:07 -0500
Received: by mail-qc0-f173.google.com with SMTP id m20so11295778qcx.4
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 16:49:05 -0800 (PST)
Received: from mythbox.ladodomain ([64.184.115.227])
        by mx.google.com with ESMTPSA id c10sm59245862qaq.16.2013.12.30.16.49.03
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 30 Dec 2013 16:49:04 -0800 (PST)
Message-ID: <52C2147E.4010902@gmail.com>
Date: Mon, 30 Dec 2013 19:49:02 -0500
From: Bob Lightfoot <boblfoot@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Question about cx23885 and tda8290 modules
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello:
	I am running Centos 6.5 with their 2.6.32-431.1.2.0.1.el6.x86_64
kernel.  My tuner card is seen as cx23885 and tda8290.  I have a
/dev/dvb/adapter0 and /dev/video0 , /dev/video1 but do not see a
/dev/radio.  the dmesg output is showing a radio tuner.  What is
missing that I don't get a /dev/radio.

Bob Lightfoot
