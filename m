Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:36262 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760958Ab3BJDCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 22:02:30 -0500
Received: by mail-we0-f177.google.com with SMTP id d7so3977770wer.8
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2013 19:02:29 -0800 (PST)
Message-ID: <51170DC3.8070302@gmail.com>
Date: Sun, 10 Feb 2013 03:02:27 +0000
From: Emile Joubert <emile.joubert@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: bt878: radio frequency stuck
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

I have the same symptoms as the ones described here:
http://article.gmane.org/gmane.linux.kernel/1214773

I have the same model card (37284) which also stopped working at commit
cbde689823776d187ba1b307a171625dbc02dd4f. Since that commit the radio
produces white noise and changing the frequency has no effect on the
sound. I've tried kernel 3.8.0-rc7 and the problem still exists in that
version.

Please let me know if there is further information I can provide towards
a solution, or if there are any patches I could try.



-Emile




