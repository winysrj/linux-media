Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61946 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0CABCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 20:02:11 -0500
Received: by fxm19 with SMTP id 19so268797fxm.21
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2010 17:02:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1267405086.3109.48.camel@palomino.walls.org>
References: <4B8AF722.8000105@helmutauer.de>
	 <1267405086.3109.48.camel@palomino.walls.org>
Date: Mon, 1 Mar 2010 05:02:09 +0400
Message-ID: <1a297b361002281702r5959ecfbja6a04183a8016d73@mail.gmail.com>
Subject: Re: Mantis not in modules.pcimap
From: Manu Abraham <abraham.manu@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Helmut Auer <vdr@helmutauer.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 1, 2010 at 4:58 AM, Andy Walls <awalls@radix.net> wrote:
> On Mon, 2010-03-01 at 00:07 +0100, Helmut Auer wrote:
>> Hello,
>>
>> The mantis module is build and working fine with the Skystar2 HD, but it I cannot autodetect it,
>> because modules.pcimap is not filled with the vendor id of the card using this module.
>> What's to do  to get these ID's ?
>> In my case its a:
>>
>> 01:08.0 0480: 1822:4e35 (rev 01)
>>       Subsystem: 1ae4:0003
>>       Flags: bus master, medium devsel, latency 32, IRQ 16
>>       Memory at fddff000 (32-bit, prefetchable) [size=4K]
>
> Running
>
>  # depmod -a
>
> as root should have added it.  The mantis driver is likely missing a
> MODULE_DEVICE_TABLE() macro invocation.
>
> Cc:-ing Manu.

Andy, Thanks.  I just replied to the same .. :-)

Regards,
Manu
