Return-path: <mchehab@gaivota>
Received: from mail-pz0-f66.google.com ([209.85.210.66]:52337 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0LaGzB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 01:55:01 -0500
Message-ID: <4D1D7A74.3030803@gmail.com>
Date: Thu, 30 Dec 2010 22:38:44 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, trivial@kernel.org,
	devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-m68k@lists.linux-m68k.org,
	spi-devel-general@lists.sourceforge.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 15/15]drivers:spi:dw_spi.c Typo change diable to disable.
References: <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com> <1293750484-1161-8-git-send-email-justinmattock@gmail.com> <1293750484-1161-9-git-send-email-justinmattock@gmail.com> <1293750484-1161-10-git-send-email-justinmattock@gmail.com> <1293750484-1161-11-git-send-email-justinmattock@gmail.com> <1293750484-1161-12-git-send-email-justinmattock@gmail.com> <1293750484-1161-13-git-send-email-justinmattock@gmail.com> <1293750484-1161-14-git-send-email-justinmattock@gmail.com> <1293750484-1161-15-git-send-email-justinmattock@gmail.com> <20101231063433.GB1886@bicker>
In-Reply-To: <20101231063433.GB1886@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/30/2010 10:34 PM, Dan Carpenter wrote:
> On Thu, Dec 30, 2010 at 03:08:04PM -0800, Justin P. Mattock wrote:
>> The below patch fixes a typo "diable" to "disable". Please let me know if this
>> is correct or not.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/spi/dw_spi.c |    6 +++---
>
> You missed one from this file:
>
> /* Set the interrupt mask, for poll mode just diable all int */
>                                                ^^^^^^
> regards,
> dan carpenter
>
>

oh-man... my grepping wasn't so grepping after all.. thanks for that 
I'll resend this one

Justin P. Mattock
