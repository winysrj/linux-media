Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:60386 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2IBO51 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 10:57:27 -0400
Message-ID: <504373D5.6040006@iki.fi>
Date: Sun, 02 Sep 2012 17:57:25 +0300
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 9/9] ir-rx51: Add missing quote mark in Kconfig text
References: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi> <1346349271-28073-10-git-send-email-timo.t.kokkonen@iki.fi> <20120901171650.GD6638@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120901171650.GD6638@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/01/12 20:16, Sakari Ailus wrote:
> Moi,
> 
> On Thu, Aug 30, 2012 at 08:54:31PM +0300, Timo Kokkonen wrote:
>> This trivial fix cures the following warning message:
>>
>> drivers/media/rc/Kconfig:275:warning: multi-line strings not supported
>>
>> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
>> ---
>>  drivers/media/rc/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
>> index 4a68014..1300655 100644
>> --- a/drivers/media/rc/Kconfig
>> +++ b/drivers/media/rc/Kconfig
>> @@ -272,7 +272,7 @@ config IR_IGUANA
>>  	   be called iguanair.
>>  
>>  config IR_RX51
>> -	tristate "Nokia N900 IR transmitter diode
>> +	tristate "Nokia N900 IR transmitter diode"
>>  	depends on OMAP_DM_TIMER && LIRC
>>  	---help---
>>  	   Say Y or M here if you want to enable support for the IR
> 
> This should be combined with patch 1.
> 

Actually I'd rather keep the patch 1 as is as it has already a purpose.
Instead, I'd squash this into patch 3 as it already touches the Kconfig
file and it has also the other trivial fixes combined in it.

-Timo

