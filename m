Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:43546 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067AbaFDAQZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jun 2014 20:16:25 -0400
Received: by mail-ob0-f171.google.com with SMTP id wn1so6960543obc.2
        for <linux-media@vger.kernel.org>; Tue, 03 Jun 2014 17:16:24 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 3 Jun 2014 20:16:24 -0400
Message-ID: <CAARpZ=-eBct+jiKTqLdbdksi6H1Y4iFcHz1e5RA2dg-zjeoKUg@mail.gmail.com>
Subject: Trouble scanning either of my cards, error "dvb_fe_set_parms failed
 (Invalid argument)"
From: Brian Caine <brian.d.caine@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

So, I have two different tv tuner cards that I'm trying to get
working. The kernel modules seem to be loading, no errors there. The
/dev/dvb files are showing up. Everything has the right permissions.
(Well, and I'm doing my testing as root too, just to get it working in
the first place.)

There are more specific boards I can go for help with each card, but
they seem to be having a common error.

One card is pcHDTV HD-5500, and it uses the cx8800 kernel module. And
the other is Hauppauge WinTV-HVR-1250, and uses the cx23885 kernel
module.

http://pastebin.com/TzNt7mTn
http://pastebin.com/m6cdLNEV

Anyone have any ideas?
