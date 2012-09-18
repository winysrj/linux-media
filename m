Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58309 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab2IRS0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 14:26:13 -0400
Received: by eaac11 with SMTP id c11so46072eaa.19
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2012 11:26:12 -0700 (PDT)
MIME-Version: 1.0
From: Henk Poley <henkpoley@gmail.com>
Date: Tue, 18 Sep 2012 20:25:51 +0200
Message-ID: <CAN_ZOpz567C=yJmKEKP_1x2pXUh4kqFgRaUY8stpqNioUQW1Yg@mail.gmail.com>
Subject: 2x TT CT-3650 CI USB = corrupt video
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Individually each of them work. When both of them are connected I get
corrupted video as soon as I tune to another channel. There is no
specific pattern in the logs, but now and then trouble about too large
packets when communicating with the CAM appears in dmesg, which could
make sense given the pervasive use of encryption by my cable provider.

I have kept a log of most of the things I've already tried here:
http://ubuntuforums.org/showthread.php?t=2054643

Is this a common problem when you use two of the same tuners? Who can
help me fix this problem?

Henk Poley
