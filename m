Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:57028 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbaIUPKt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 11:10:49 -0400
Received: from [192.168.1.21] ([79.215.138.24]) by mail.gmx.com (mrgmx102)
 with ESMTPSA (Nemesis) id 0MKKaI-1XU4cj26fG-001lIx for
 <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 17:10:47 +0200
Message-ID: <541EEA74.2000909@gmx.net>
Date: Sun, 21 Sep 2014 17:10:44 +0200
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Running Technisat DVB-S2 on ARM-NAS
References: <541EE016.9030504@gmx.net> <541EE2EB.4000802@iki.fi>
In-Reply-To: <541EE2EB.4000802@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> How my I find out more about the error -12? 
> 
> http://www.virtsync.com/c-error-codes-include-errno
> 
> #define ENOMEM      12  /* Out of memory */
> 
> Likely allocating USB stream buffers fails. You could try request
> smaller buffers. Drop count to 1 and test. Drop framesperurb to 1 and
> test. Drop framesize to 1 and test. Surely streaming will not work if
> all buffers are totally wrong and too small, but you will see if it is
> due to big usb buffers. Then you could try optimize buffers smaller.
> 

Wow, that did it. Thanks Antti!

Works with count = 2, but not with count = 4.

What exactly do I learn from this?
Where are those buffers? In the RAM? or somewhere in onboard USB hardware?

VDR is now able to connect to the device, but I am not sure if it
receives anything yet.

Jan

