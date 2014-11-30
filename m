Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:39145 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaK3Rzc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Nov 2014 12:55:32 -0500
Received: by mail-ob0-f179.google.com with SMTP id va2so6910027obc.38
        for <linux-media@vger.kernel.org>; Sun, 30 Nov 2014 09:55:31 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 30 Nov 2014 18:55:31 +0100
Message-ID: <CA+QJwyhPLM32nR4UUy9vZ_xMSzZrRbnjh2yv__bW=GJRix3XHw@mail.gmail.com>
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
From: =?UTF-8?B?SXN0dsOhbiwgVmFyZ2E=?= <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By the way, from the xc4000_firmware.tar.gz package, the only files
that are actually needed are:
  build_fw.c (source code of simple program to write the firmware file)
  xc4000_firmwares.h (header file from Xceive)
  xc4000_scodes.h (also from Xceive)

Everything else is related to extracting the firmware from Windows drivers,
and was included only for completeness.

The license for the Xceive header files can be found here:
  http://www.kernellabs.com/firmware/xc4000/README.xc4000
