Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm25-vm7.bullet.mail.ird.yahoo.com ([212.82.109.208]:33788 "EHLO
	nm25-vm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932482Ab3FEVX6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jun 2013 17:23:58 -0400
Message-ID: <1370467435.98583.YahooMailNeo@web28903.mail.ir2.yahoo.com>
Date: Wed, 5 Jun 2013 22:23:55 +0100 (BST)
From: marco caminati <marco.caminati@yahoo.it>
Reply-To: marco caminati <marco.caminati@yahoo.it>
Subject: rtl28xxu ir remote
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the recent efforts as from subject.
I tested it with no success, however.
Indeed, with old r820t-unaware drivers (e.g., v4l version df33bbd60225), I used to get some output from

cat /dev/input/eventX

upon pressing ir remote buttons (passingrtl2832u_rc_mode=2 to modprobe).

Now this does not work any longer.
