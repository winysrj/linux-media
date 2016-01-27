Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33933 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbcA0AKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 19:10:15 -0500
Received: by mail-pa0-f44.google.com with SMTP id uo6so107740510pac.1
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2016 16:10:14 -0800 (PST)
Received: from wrs.home ([184.64.124.158])
        by smtp.gmail.com with ESMTPSA id yh5sm4303140pab.13.2016.01.26.16.10.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Jan 2016 16:10:13 -0800 (PST)
Message-ID: <1453853412.11523.7.camel@gmail.com>
Subject: /dev/lirc0 no longer gets created in recent fedora kernels
From: Warren Sturm <warren.sturm@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 26 Jan 2016 17:10:12 -0700
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This applies to 4.3.3-300 through 4.5.0-0.rc0.git7.1 from rawhide.  At
least 4.5.0-0.rc0.git7.1 fixes the ivtv inputs problem.

I am using a cx18 as an ir-blaster.  Both lirc_dev and lirc_zilog get
loaded but the device is unavailable.

This does work in 4.2.8 except the ivtv inputs part but that's a 3 hour
workaround.


