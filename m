Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:58035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbZLFMNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 07:13:47 -0500
Date: 06 Dec 2009 13:12:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: jonsmirl@gmail.com
Cc: awalls@radix.net
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: jarod@wilsonet.com
Cc: khc@pm.waw.pl
Cc: kraxel@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BENh5lRHqgB@lirc>
In-Reply-To: <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

on 04 Dec 09 at 19:28, Jon Smirl wrote:
>> BTW, I just came across a XMP remote that seems to generate 3x64 bit
>> scan codes. Anyone here has docs on the XMP protocol?
>
> Assuming a general purpose receiver (not one with fixed hardware
> decoding), is it important for Linux to receive IR signals from all
> possible remotes no matter how old or obscure? Or is it acceptable to
[...]
> Of course transmitting is a completely different problem, but we
> haven't been talking about transmitting. I can see how we would need
> to record any IR protocol in order to retransmit it. But that's in the
> 5% of users world, not the 90% that want MythTV to "just work".  Use
> something like LIRC if you want to transmit.

I don't think anyone here is in the position to be able to tell what is  
90% or 5%. Personally I use LIRC exclusively for transmit to my settop box  
using an old and obscure RECS80 protocol.
No, I won't replace my setup just because it's old and obscure.

Cable companies tend to provide XMP based boxes to subscribers more often  
these days. Simply not supporting these setups is a no-go for me.

Christoph
