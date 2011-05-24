Return-path: <mchehab@pedra>
Received: from yop.chewa.net ([91.121.105.214]:56131 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab1EXKz1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 06:55:27 -0400
To: <linux-media@vger.kernel.org>
Subject: dvb: one demux per tuner or one demux per =?UTF-8?Q?demod=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 24 May 2011 12:55:25 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: <vlc-devel@videolan.org>
Message-ID: <719f9c4d1bd57d5b2711bc24a9d5c3b1@chewa.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

   Hello,



Been testing the bleeding-edge Hauppauge 290E (em28174 + Sony cxd2820r)

from Antti Palosaari and Steve Kerrison, now in linux-media GIT tree.



It seems the device creates two frontends and only one demux/dvr nodes.

Are they not supposed to be one demux per frontend? Or how is user-space

supposed to map the demux/dvr and the frontend, on a multi-proto card? on a

multi-tuner card?



Best regards,



-- 

Rémi Denis-Courmont

http://www.remlab.net/
