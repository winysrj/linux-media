Return-path: <mchehab@gaivota>
Received: from mail-pz0-f66.google.com ([209.85.210.66]:62643 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0LaOPX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 09:15:23 -0500
Message-ID: <4D1DE58C.1050305@gmail.com>
Date: Fri, 31 Dec 2010 06:15:40 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
CC: trivial@kernel.org, linux-m68k@lists.linux-m68k.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-scsi@vger.kernel.org,
	spi-devel-general@lists.sourceforge.net,
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 14/15]include:media:davinci:vpss.h Typo change diable
 to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <1293750484-1161-3-git-send-email-justinmattock@gmail.com> <1293750484-1161-4-git-send-email-justinmattock@gmail.com> <1293750484-1161-5-git-send-email-justinmattock@gmail.com> <1293750484-1161-6-git-send-email-justinmattock@gmail.com> <1293750484-1161-7-git-send-email-justinmattock@gmail.com> <1293750484-1161-8-git-send-email-justinmattock@gmail.com> <1293750484-1161-9-git-send-email-justinmattock@gmail.com> <1293750484-1161-10-git-send-email-justinmattock@gmail.com> <1293750484-1161-11-git-send-email-justinmattock@gmail.com> <1293750484-1161-12-git-send-email-justinmattock@gmail.com> <1293750484-1161-13-git-send-email-justinmattock@gmail.com> <1293750484-1161-14-git-send-email-justinmattock@gmail.com> <4D1DAFF5.3090108@gmail.com>
In-Reply-To: <4D1DAFF5.3090108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/31/2010 02:27 AM, Mauro Carvalho Chehab wrote:
> Em 30-12-2010 21:08, Justin P. Mattock escreveu:
>> The below patch fixes a typo "diable" to "disable". Please let me know if this
>> is correct or not.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> Acked-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> PS.: Next time, please c/c linux-media ONLY on patches related to media
> drivers (/drivers/video and the corresponding include files). Having to
> dig into a series of 15 patches to just actually look on 3 patches
> is not nice.
>

alright...

>>
>> ---
>>   include/media/davinci/vpss.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/media/davinci/vpss.h b/include/media/davinci/vpss.h
>> index c59cc02..b586495 100644
>> --- a/include/media/davinci/vpss.h
>> +++ b/include/media/davinci/vpss.h
>> @@ -44,7 +44,7 @@ struct vpss_pg_frame_size {
>>   	short pplen;
>>   };
>>
>> -/* Used for enable/diable VPSS Clock */
>> +/* Used for enable/disable VPSS Clock */
>>   enum vpss_clock_sel {
>>   	/* DM355/DM365 */
>>   	VPSS_CCDC_CLOCK,
>
>

Justin P. Mattock
