Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43035 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0JBLih (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Oct 2010 07:38:37 -0400
Received: by eyb6 with SMTP id 6so1477979eyb.19
        for <linux-media@vger.kernel.org>; Sat, 02 Oct 2010 04:38:36 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 2 Oct 2010 12:38:34 +0100
Message-ID: <AANLkTikPJ4pLR8R-HG599ESCdRiFzdmVrNKAAV2EnKdM@mail.gmail.com>
Subject: pending ov7670/cafe_ccic patches
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Just a quick reminder about 4 pending cafe_ccic/ov7670 patches, all
acked by Jon Corbet:

http://www.spinics.net/lists/linux-media/msg23371.html
http://www.spinics.net/lists/linux-media/msg23373.html
http://www.spinics.net/lists/linux-media/msg23372.html
http://www.spinics.net/lists/linux-media/msg23369.html

The patches were made against linus master so don't account for
changes that have happened since then (such as the mbus stuff).
However the patches are all still valid without modification and git's
default merge algo applies them just fine. Let me know if you'd like
me to resend them anyway based on your latest tree.

cheers
Daniel
