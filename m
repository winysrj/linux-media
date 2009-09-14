Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:60284 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbZINPmJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 11:42:09 -0400
Received: by fxm17 with SMTP id 17so928515fxm.37
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 08:42:12 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 Sep 2009 17:42:12 +0200
Message-ID: <746d58780909140842o8952bf1g8f7851eee9ec0093@mail.gmail.com>
Subject: how to get a registered adapter name
From: Benedict bdc091 <bdc091@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,

I'd like to enumerate connected DVB devices from my softawre, based on
DVB API V3.
Thank to ioctl FE_GET_INFO, I'm able to get frontends name, but they
are not "clear" enough for users.

After a "quick look" in /var/log/messages I discovered that adapters
name are much expressives:

> ...
> DVB: registering new adapter (ASUS My Cinema U3000 Mini DVBT Tuner)
> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> ...

So, I tried to figure out a way to get "ASUS My Cinema U3000 Mini DVBT
Tuner" string from adapter, instead of "DiBcom 7000PC" from adapter's
frontend...
Unsuccefully so far.

Any suggestions?


Regards
--
Benedict
