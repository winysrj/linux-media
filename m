Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:62019 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1GZMRX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 08:17:23 -0400
Received: by eye22 with SMTP id 22so532428eye.2
        for <linux-media@vger.kernel.org>; Tue, 26 Jul 2011 05:17:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <j0m9s7$e9j$1@dough.gmane.org>
References: <AANLkTinprP=o6_TnPjj1ieZAp27qmW-nuWHq04dN1oVp@mail.gmail.com>
	<AANLkTi=-umKif5pGz-adhZhtcd8CnJJsZ1pzHn0ttvwA@mail.gmail.com>
	<j0m9s7$e9j$1@dough.gmane.org>
Date: Tue, 26 Jul 2011 08:17:04 -0400
Message-ID: <CAGoCfizFA75Lyyx49EEJO9n5Smw1trBX7Azdu1iYrAqpYnDE8g@mail.gmail.com>
Subject: Re: driver problem: cx231xx error -71 with Hauppauge USB live2 on
 Ubuntu 11.04, netbook edition
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Doychin Dokov <root@net1.cc>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 26, 2011 at 7:53 AM, Doychin Dokov <root@net1.cc> wrote:
> [416830.939483] cx231xx #0: can't change interface 3 alt no. to 0 (err=-71)
>
> This is with the stock kernel, no media_build tree installed (I'm currently
> compiling it).

Patches for this issue were submitted over the weekend.  Check the
mailing list for posts from Saturday or wait a few days for the
patches to be merged into the linux_media tree.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
