Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:35000 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZAKWqh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 17:46:37 -0500
Received: by ewy10 with SMTP id 10so11224234ewy.13
        for <linux-media@vger.kernel.org>; Sun, 11 Jan 2009 14:46:35 -0800 (PST)
From: "Alec Christie" <alec.christie@gmail.com>
To: <linux-media@vger.kernel.org>
Subject: Soft Lockup Caused by recent build of v4l-dvb
Date: Sun, 11 Jan 2009 22:46:32 -0000
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-gb
Message-ID: <496a76ca.0a1ad00a.1f27.ffff9069@mx.google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I have recently upgraded my kernel (Ubuntu HH to 2.6.24-22) and thus had to
re-build the v4l-dvb driver to make my HVR4000 card work again (it was
working before the kernel upgrade). I hg clone'd the
http://linuxtv.org/hg/v4l-dvb/, then "make && make install"'d it, re-booted
and now the machine stalls on boot with error: "BUG: soft lockup CPU#0
(modprobe)".

I have tested again without the v4l-dvb driver and it works fine. My system
is below:

2x P4 Xeons
ASUS PCH-DL Mobo
Hauppauge WinTV HVR-4000
Leadtek WinFast DTV1000
Ubuntu Hardy Heron

Any ideas?

Kind Regards,

Alec Christie


