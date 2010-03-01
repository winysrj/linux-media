Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:46343 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0CAGg3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 01:36:29 -0500
Received: by ewy20 with SMTP id 20so1045896ewy.21
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2010 22:36:27 -0800 (PST)
Date: Mon, 1 Mar 2010 15:36:45 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [IR RC, REGRESSION] Didn't work IR RC
Message-ID: <20100301153645.5d529766@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

After rework of the IR subsystem, IR RC no more work in our TV cards.
As I see 
call saa7134_probe_i2c_ir,
  configure i2c
  call i2c_new_device

New i2c device not registred.

The module kbd-i2c-ir loaded after i2c_new_device.

I try to found what happens.

With my best regards, Dmitry.
