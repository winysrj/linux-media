Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:55908 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbbL1Mi5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2015 07:38:57 -0500
Received: from [192.168.1.2] ([78.48.234.128]) by smtp.web.de (mrweb103) with
 ESMTPSA (Nemesis) id 0Lheqz-1ZrNXi2kKn-00mq6o for
 <linux-media@vger.kernel.org>; Mon, 28 Dec 2015 13:38:55 +0100
To: linux-media@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [media] r820t: Checking lock scopes around i2c_gate_ctrl() calls?
Message-ID: <56812D5D.1020800@users.sourceforge.net>
Date: Mon, 28 Dec 2015 13:38:53 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have looked at the implementation of the function "r820t_signal" once more.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/media/tuners/r820t.c?id=80c75a0f1d81922bf322c0634d1e1a15825a89e6#n2242

The function which was assigned to the pointer "i2c_gate_ctrl" from
the variable "fe" (data structure "dvb_frontend") is called after a mutex
was locked. Would it make sense to reconsider the size of this lock scope?

Regards,
Markus
