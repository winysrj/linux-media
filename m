Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:34001 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbcFIMth (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2016 08:49:37 -0400
Received: by mail-pf0-f174.google.com with SMTP id 62so13287183pfd.1
        for <linux-media@vger.kernel.org>; Thu, 09 Jun 2016 05:49:37 -0700 (PDT)
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com
From: Akihiro TSUKADA <tskd08@gmail.com>
Subject: dvb-core: how should i2c subdev drivers be attached?
Message-ID: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
Date: Thu, 9 Jun 2016 21:49:33 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
excuse me for taking up a very old post again,
but I'd like to know the status of the patch:
  https://patchwork.linuxtv.org/patch/27922/
, which provides helper code for defining/loading i2c DVB subdev drivers.

Was it rejected and 
each i2c demod/tuner drivers should provide its own version of "attach" code?
Or is it acceptable (with some modifications) ?

Although not many drivers currently use i2c binding model (and use dvb_attach()),
but I expect that coming DVB subdev drivers will have a similar attach code,
including module request/ref-counting, device creation,
(re-)using i2c_board_info.platformdata to pass around both config parameters
and the resulting i2c_client* & dvb_frontend*.

Since I have a plan to split out demod/tuner drivers from pci/pt1 dvb-usb/friio
integrated drivers (because those share the tc90522 demod driver with pt3, and
friio also shares the bridge chip with gl861),
it would be nice if I can use the helper code,
instead of re-iterating similar "attach" code.

--
akihiro
