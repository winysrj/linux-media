Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:35031 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbbGTQp7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 12:45:59 -0400
Received: by ykdu72 with SMTP id u72so143293104ykd.2
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 09:45:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AD234E.5010904@iki.fi>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<55AD0617.7060007@iki.fi>
	<CALzAhNVFBgEBJ8448h1WL3iDZ4zkR_k5And0-mtJ6vu97RZLTQ@mail.gmail.com>
	<55AD234E.5010904@iki.fi>
Date: Mon, 20 Jul 2015 12:45:58 -0400
Message-ID: <CAGoCfiy5Fy26EJzRPYEk_kgH0YESTXiR-E=83Rur6PWZjyi8jQ@mail.gmail.com>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Steven Toth <stoth@kernellabs.com>, tonyc@wincomm.com.tw,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Look at the em28xx driver and you will probably see why it does not work as
> expected. For my eyes, according to em28xx driver, it looks like that bus
> control is aimed for bridge driver. You or em28xx is wrong.

Neither are wrong.  In some cases the call needs to be intercepted by
the frontend in order to disable its TS output.  In other cases it
needs to be intercepted by the bridge to control a MUX chip which
dictates which demodulator's TS output to route from (typically by
toggling a GPIO).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
