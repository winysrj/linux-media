Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56067 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKQQV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 11:21:59 -0500
Received: by mail-pa0-f45.google.com with SMTP id lf10so22491227pab.4
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 08:21:58 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 17 Nov 2014 20:21:58 +0400
Message-ID: <CANZNk81ZmCRq0Cw3Sep-VGCYb6ELAmpNPpJ=jwk-aUTamB=f3A@mail.gmail.com>
Subject: git.linuxtv.org repos refuse to fetch
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This happens always, and I noticed it quite long time ago. At the
moment I have 1 mbit internet link, but AFAIR it was the same with
much bigger bandwidth.

20:17:06krieger@zver /usr/local/src/linux-next
 $ git remote add verk_media_tree git://linuxtv.org/hverkuil/media_tree.git
[OK]
20:17:16krieger@zver /usr/local/src/linux-next
 $ git fetch verk_media_tree
fatal: read error: Connection reset by peer
[ERR]


"git clone" seems to work, at last it starts; but i haven't done full
clone from it yet, at the moment i've started it and now it is
"counting objects".
-- 
Andrey Utkin
