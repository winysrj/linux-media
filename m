Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:59825 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZHCMQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 08:16:57 -0400
Received: by yxe5 with SMTP id 5so1893988yxe.33
        for <linux-media@vger.kernel.org>; Mon, 03 Aug 2009 05:16:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1E944549-0765-4A47-B8DC-86DF8E46F773@mac.com>
References: <bb2708720907300849m78b24a3av3721ccf272cbaa5b@mail.gmail.com>
	 <bb2708720907301223h616eb215gb4aea1df8e1d578e@mail.gmail.com>
	 <alpine.DEB.2.00.0908021919320.19529@utopia.booyaka.com>
	 <bb2708720908030333x1c9521b6ua76122b0f80e1fdc@mail.gmail.com>
	 <52AC0DF6-BA95-421B-8C56-5F3DC62279DF@mac.com>
	 <bb2708720908030356p6d7b1cdegf0bd8c39a5c4ecd9@mail.gmail.com>
	 <1E944549-0765-4A47-B8DC-86DF8E46F773@mac.com>
Date: Mon, 3 Aug 2009 08:16:56 -0400
Message-ID: <bb2708720908030516r60fbf617rf3f3423bfc74b6e7@mail.gmail.com>
Subject: Re: MMC3 Overo
From: John Sarman <johnsarman@gmail.com>
To: Elvis Dowson <elvis.dowson@mac.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 3, 2009 at 6:59 AM, Elvis Dowson<elvis.dowson@mac.com> wrote:
> Hi,
>
> On Aug 3, 2009, at 2:56 PM, John Sarman wrote:
>
>> On Mon, Aug 3, 2009 at 6:37 AM, Elvis Dowson<elvis.dowson@mac.com> wrote:
>>>
>> MMC3 connects to one of the 70 pin bottom connectors.
>
> Is this for some custom board? I am using the standard Overo Earth + palo43
> combo. Just want to know if I need to apply the mmc3 patch or not.
Yeah, sorry  it is a 100% custom board. The 32 mmc patches released do
apply, but the IRQ fix is only needed if you plan to use mmc3.
>
> The existing mmc reader on board the overo, is it connected to mmc1 or mmc3?
>
> Best regards,
>
> Elvis
>
>
>
>
