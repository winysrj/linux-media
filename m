Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48668 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZJXQB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 12:01:59 -0400
Received: by pwj9 with SMTP id 9so644860pwj.21
        for <linux-media@vger.kernel.org>; Sat, 24 Oct 2009 09:02:03 -0700 (PDT)
Message-ID: <4AE324F9.9050305@gmail.com>
Date: Sun, 25 Oct 2009 00:02:01 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: v4l-dvb <linux-media@vger.kernel.org>
Subject: [RFC]MAX2165 and ATBM8830
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

   I am working on Mygica X8558Pro GB20600(A.K.A DMB-TH) with help from 
hardware vendor. It features Maxim MAX2165 tuner and Altobeam ATBM8830 
demodulator.

   I've created a repository at 
http://bitbucket.org/davidtlwong/mygica_x8558pro

   You can get a copy by:
hg clone http://bitbucket.org/davidtlwong/mygica_x8558pro

   The code are not working yet. Any help to improve the code is 
extremely welcome. If anyone need some code for MAX2165 or ATBM8830,
it may helps for a reference.

Regards,
David T.L. Wong
