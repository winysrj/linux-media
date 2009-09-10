Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:55419 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZIJUaP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 16:30:15 -0400
Received: by fxm17 with SMTP id 17so389650fxm.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 13:30:17 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 Sep 2009 22:30:17 +0200
Message-ID: <3c031ccc0909101330p47b355e1vc95938ccbf99df90@mail.gmail.com>
Subject: TeVii S650 DVB-S2 USB und s2-liplianin drivers
From: crow <crow@linux.org.ba>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I tried today s2-liplianin drivers with tevii s650 and vdr cant lock
any channels with this error msg:

<---snip---->
<6>stv0900_search: <7><6>Search Fail
stv0900_read_status: <7>DEMOD LOCK FAIL
stv0900_read_status: <7>DEMOD LOCK FAIL
<6>stb0900_set_property(..)
<6>stv0900_set_tone: On
<---snip--->

Then i found from old installation compiled drivers from rev12458 and
installed it and everything work fine
(s2-liplianin-hg-12458-1-i686.pkg.tar.gz).

I am on archlinux x86 with 2.6.30.5-1 kernel
