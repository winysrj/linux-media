Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64665 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2IQKGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 06:06:00 -0400
Received: by bkwj10 with SMTP id j10so2374974bkw.19
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2012 03:05:59 -0700 (PDT)
Message-ID: <5056F605.7040006@gmail.com>
Date: Mon, 17 Sep 2012 12:05:57 +0200
From: =?ISO-8859-15?Q?Klaus-Dieter_M=F6ller?= <kdmoeller57@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: TerraTec Cinergy T PCIe dual freezes the system
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,
I want to use 2 TerraTec Cinergy T PCIe dual PCIe-cards in the same 
system. Both cards are working without any problems if used standalone. 
If both cards are used parallel the hole system freezes mostly on 
loading the kernel modules. There are no error messages in the log 
files. Sometimes (very seldom) the modules are loaded successfully and 
then both cards can work over hours without problems. Freezing occurs 
before starting a dvb application.Maybe someone has an idea what to do.
