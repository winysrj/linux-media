Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f227.google.com ([209.85.219.227]:62144 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZIOEMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 00:12:46 -0400
Received: by ewy27 with SMTP id 27so4043457ewy.40
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 21:12:49 -0700 (PDT)
Date: Tue, 15 Sep 2009 14:13:22 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com,
	linux-media <linux-media@vger.kernel.org>
Subject: saa7134 and soft SPI bus
Message-ID: <20090915141322.48a3f64c@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All.

Our new TV card has MPEG-2 encoder NEC µPD61151. This encoder hasn't I2C bus, only SPI.
Can you point me how to make software SPI bus via GPIO of the saa7134. Better way for do it.

With my best regards, Dmitry.
