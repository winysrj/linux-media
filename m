Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbZKWVMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 16:12:31 -0500
Date: 23 Nov 2009 22:11:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: khc@pm.waw.pl
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDRae8rZjFB@christoph>
In-Reply-To: <m36391tjj3.fsf@intrepid.localdomain>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Czesc Krzysztof,

on 23 Nov 09 at 15:14, Krzysztof Halasa wrote:
[...]
> I think we shouldn't at this time worry about IR transmitters.

Sorry, but I have to disagree strongly.
Any interface without transmitter support would be absolutely unacceptable  
for many LIRC users, including myself.

Christoph
