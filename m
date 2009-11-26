Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbZKZIjW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 03:39:22 -0500
Message-ID: <4B0E3EA4.7000003@redhat.com>
Date: Thu, 26 Nov 2009 09:39:00 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: awalls@radix.net, dheitmueller@kernellabs.com,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDcbfiXJjFB@christoph>
In-Reply-To: <BDcbfiXJjFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/26/09 08:28, Christoph Bartelmus wrote:
> Hi Gerd,
>
> on 26 Nov 09 at 00:22, Gerd Hoffmann wrote:
> [...]
>>> To sum it up: I don't think this information will be useful at all for
>>> lircd or anyone else.
> [...]
>> I know that lircd does matching instead of decoding, which allows to
>> handle unknown encodings.  Thats why I think there will always be cases
>> which only lircd will be able to handle (using raw samples).
>>
>> That doesn't make attempts to actually decode the IR samples a useless
>> exercise though ;)
>
> Well, in my opinion it is kind of useless. I don't see any use case or any
> demand for passing this kind of information to userspace, at least in the
> LIRC context.
> If there's no demand, why bother?

There have been complains about this getting lost somewhere in this 
thread, so it looks like there are people which do care.

cheers,
   Gerd
