Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:46729 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbbBPQMl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 11:12:41 -0500
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com [209.85.215.48])
	by imap.netup.ru (Postfix) with ESMTPA id 4D4D06CDF6E
	for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 19:04:48 +0300 (MSK)
Received: by lamq1 with SMTP id q1so30103382lam.5
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 08:04:47 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 16 Feb 2015 11:04:47 -0500
Message-ID: <CAK3bHNUaC=XoqREJMTWAAP=i+nPjcsQQPehS0--rk12Yhhn16g@mail.gmail.com>
Subject: Opening firmware source code (vhdl)
From: Abylay Ospan <aospan@netup.ru>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

We're fully opening firmware sources for our new card - NetUP Dual
Universal DVB CI. License is GPLv3. Sources is VHDL for Altera FPGA
EP4CGX22CF19C8
and can be compiled with Altera Quartus II (free edition). Hope this
will help for enthusiasts and developers to deeply understand hardware
part of DVB card.

Source code:
https://github.com/aospan/NetUP_Dual_Universal_CI-fpga

Here is a description for building and uploading fw into DVB card:
http://linuxtv.org/wiki/index.php/FPGA_fw_for_NetUP_Dual_Universal_CI

Feel free to contact me for any questions or comments.

-- 
Abylay Ospan,
NetUP Inc.
http://www.netup.tv
