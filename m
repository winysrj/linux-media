Return-path: <mchehab@gaivota>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37490 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab0LOJb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 04:31:58 -0500
Received: by iyi12 with SMTP id 12so787113iyi.19
        for <linux-media@vger.kernel.org>; Wed, 15 Dec 2010 01:31:58 -0800 (PST)
MIME-Version: 1.0
Reply-To: debarshi.ray@gmail.com
Date: Wed, 15 Dec 2010 11:31:57 +0200
Message-ID: <AANLkTi=FMQQCq1ojFnm1YzteVvC7TB90XiQvxK21F8EG@mail.gmail.com>
Subject: technisat cablestar hd2, cinergy C pci hd, 2.6.35, no remote (VP2040)
From: Debarshi Ray <debarshi.ray@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>,
	Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is with reference to:
http://www.spinics.net/lists/linux-media/msg15042.html

It looks to me that the IR interface related stuff is not in the
2.6.35 kernel either. Since I need it for a set-top box that I
building, I was looking for the canonical source for that code so that
I can package it separately. Till now I have only found the bits in
Igor's s2-liplianin tree. However it looks to me that the code did not
originate there because the RC keymap file
(linux/drivers/media/IR/keymaps/rc-vp2040.c) was created by a commit
marked "merge http://linuxtv.org/hg/v4l-dvb" (hg export 15052). I am
confused because the v4l-dvb tree does not have the VP2040 IR bits,
and my limited knowledge of Mercurial is hindering me from figuring
out the origins of the code.

Could you kindly point me to the correct direction?

Thanks,
Debarshi

-- 
The camera is to the brush what Java is to assembly.
   -- Sougata Santra
