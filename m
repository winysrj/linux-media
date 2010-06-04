Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0FDSog (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jun 2010 14:44:36 -0400
Message-ID: <4C09498F.6070909@infradead.org>
Date: Fri, 04 Jun 2010 15:44:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND] FusionHDTV: Use quick reads for I2C IR device
 probing
References: <20100526150511.3e2560ed@hyperion.delvare> <20100604171404.27fe7773@hyperion.delvare>
In-Reply-To: <20100604171404.27fe7773@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-06-2010 12:14, Jean Delvare escreveu:
> Mauro,
> 
> On Wed, 26 May 2010 15:05:11 +0200, Jean Delvare wrote:
>> IR support on FusionHDTV cards is broken since kernel 2.6.31. One side
>> effect of the switch to the standard binding model for IR I2C devices
>> was to let i2c-core do the probing instead of the ir-kbd-i2c driver.
>> There is a slight difference between the two probe methods: i2c-core
>> uses 0-byte writes, while the ir-kbd-i2c was using 0-byte reads. As
>> some IR I2C devices only support reads, the new probe method fails to
>> detect them.
>>
>> For now, revert to letting the driver do the probe, using 0-byte
>> reads. In the future, i2c-core will be extended to let callers of
>> i2c_new_probed_device() provide a custom probing function.
>>
>> Signed-off-by: Jean Delvare <khali@linux-fr.org>
>> Tested-by: "Timothy D. Lenz" <tlenz@vorgon.com>
>> ---
>> This fix applies to kernels 2.6.31 to 2.6.34. Should be sent to Linus
>> quickly. I had already sent on March 29th, but apparently it was
>> overlooked. I have further i2c patches which depend on this one, so
>> please process it quickly, otherwise I'll have to push it myself.
> 
> This fix is still not upstream! What do I have to do to get it there?
> Please!

Just sent a pull request.

Cheers,
Mauro
