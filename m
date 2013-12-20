Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:48978 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab3LTUXc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Dec 2013 15:23:32 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so2889309wes.26
        for <linux-media@vger.kernel.org>; Fri, 20 Dec 2013 12:23:31 -0800 (PST)
Received: from [192.168.1.110] (093105185086.warszawa.vectranet.pl. [93.105.185.86])
        by mx.google.com with ESMTPSA id pl7sm3410441wjc.16.2013.12.20.12.23.29
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 20 Dec 2013 12:23:30 -0800 (PST)
Message-ID: <52B4A741.5080901@gmail.com>
Date: Fri, 20 Dec 2013 21:23:29 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL v2]  Samsung S5K6BAF image sensor driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 0400c5354ad09bf4c754132992bdde9ef3dbefcd:

   [media] dib8000: improve block statistics (2013-12-19 08:17:47 -0200)

are available in the git repository at:
   git://linuxtv.org/snawrocki/samsung.git v3.14-s5k5baf

Andrzej Hajda (2):
       Add DT binding documentation for Samsung S5K5BAF camera sensor
       Add driver for Samsung S5K5BAF camera sensor

  .../devicetree/bindings/media/samsung-s5k5baf.txt  |   58 +
  MAINTAINERS                                        |    7 +
  drivers/media/i2c/Kconfig                          |    7 +
  drivers/media/i2c/Makefile                         |    1 +
  drivers/media/i2c/s5k5baf.c                        | 2043 
++++++++++++++++++++
  5 files changed, 2116 insertions(+), 0 deletions(-)
  create mode 100644 
Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
  create mode 100644 drivers/media/i2c/s5k5baf.c

Comparing to the first version I just removed a duplicated Signed-off-by 
tag.
