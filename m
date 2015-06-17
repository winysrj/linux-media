Return-path: <linux-media-owner@vger.kernel.org>
Received: from odpn1.odpn.net ([212.40.96.53]:33765 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbbFQGc3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2015 02:32:29 -0400
From: "Gabor Z. Papp" <gzpapp.lists@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx problem with 3.10-4.0
References: <x6d212hdgj@gzp> <x6d20wi1ml@gzp>
	<20150616062056.34b4d4ef@recife.lan>
Date: Wed, 17 Jun 2015 08:32:26 +0200
Message-ID: <x6oakedev9@gzp>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

| Nothing. You just ran out of continuous memory. This driver
| requires long chunks of continuous memory for USB data transfer.

And there is no way to preset some mem?
Or do something to get the driver work again?
I don't think I'm using too much memory.

$ free
             total       used       free     shared    buffers     cached
Mem:       2073656     625696    1447960          0      21072     231096
-/+ buffers/cache:     373528    1700128
Swap:      1004056          0    1004056
