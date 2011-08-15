Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42487 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab1HONEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 09:04:04 -0400
Received: by wwf5 with SMTP id 5so4826332wwf.1
        for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 06:04:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108152232.46744.declan.mullen@bigpond.com>
References: <201108150923.44824.declan.mullen@bigpond.com>
	<CAGoCfixyKbR4rJUjxpSu2H2ss=jbk45VEJiPeSzq6FO0G7EFbQ@mail.gmail.com>
	<201108152109.53885.declan.mullen@bigpond.com>
	<201108152232.46744.declan.mullen@bigpond.com>
Date: Mon, 15 Aug 2011 09:04:03 -0400
Message-ID: <CALzAhNW2iZA7f=hj+Kao055T-z5C-z4sArX7OE=JHU1DiyRx2Q@mail.gmail.com>
Subject: Re: How to git and build HVR-2200 drivers from Kernel labs ?
From: Steven Toth <stoth@kernellabs.com>
To: Declan Mullen <declan.mullen@bigpond.com>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> So how do I get a 8940 edition of a HVR-2200 working with Ubuntu ?

Hello Declan,

You'll need to install the entire new kernel and all of its modules,
you should avoid cherry picking small pieces.

Incidentally, I've had confirmation from another user that the tree
works and automatically detects type 9 cards.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
