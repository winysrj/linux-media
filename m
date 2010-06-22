Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50461 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab0FVBTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 21:19:24 -0400
Received: by yxl31 with SMTP id 31so585222yxl.19
        for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 18:19:23 -0700 (PDT)
Received: from [10.16.0.66] (chumley.hagood.sktc.net [10.16.0.66])
	by Deathwish.hagood.sktc.net (Postfix) with ESMTP id 3CFD5C7B8044
	for <linux-media@vger.kernel.org>; Mon, 21 Jun 2010 20:19:20 -0500 (CDT)
Subject: Laptop failing to suspend when WinTV-HVR950 installed.
From: David Hagood <david.hagood@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 20:19:20 -0500
Message-ID: <1277169560.6715.6.camel@chumley>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a 100% repeatable failure for my laptop runing Lucid 64 bit to
suspend when my WinTV-HVR950 is installed, and a 100% success rate on it
suspending when the device is not installed.

If I put the device in, remove the device, and suspend (e.g. by closing
the lid) it will suspend. There are no processes opening the device (as
confirmed by lsof | grep dvb).

Additionally, most of the time the failure to suspend occurs, the
machine becomes unresponsive, and I have to hard power off to get it
back.

Has anybody else seen this?


