Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34554 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab1CGNuF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 08:50:05 -0500
Received: by fxm17 with SMTP id 17so4082889fxm.19
        for <linux-media@vger.kernel.org>; Mon, 07 Mar 2011 05:50:04 -0800 (PST)
Message-ID: <4D74E28A.6030302@gmail.com>
Date: Mon, 07 Mar 2011 14:50:02 +0100
From: Martin Vidovic <xtronom@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: ngene CI problems
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all!

I'm trying to make the DVB_DEVICE_SEC approach work, however I'm 
experiencing certain problems with the following setup:

Software:
Linux 2.6.34.8 (vanilla)
drivers from http://linuxtv.org/hg/~endriss/v4l-dvb/

Hardware:
Digital Devices CineS2 + CI Module

Problems:

- Packets get lost in SEC device:

I write complete TS to SEC, but when reading from SEC there are 
discontinuities on the CC.

- SEC device generates NULL packets (ad infinitum):

When reading from SEC, NULL packets are read and interleaved with 
expected packets. They can be even read with dd(1) when nobody is 
writing to SEC and even when CAM is not ready.

- SEC device blocks on CAM re-insertion:

When CAM is removed from the slot and inserted again, all read() 
operations just hang. Rebooting resolves the problem.

- SEC device does not respect O_NONBLOCK:

In connection to the previous problem, SEC device blocks even if opened 
with O_NONBLOCK.

Best regards,
Martin Vidovic
