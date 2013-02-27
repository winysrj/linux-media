Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.stepping-stone.ch ([194.176.109.206]:60764 "EHLO
	mail.stepping-stone.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760007Ab3B0NpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 08:45:14 -0500
Message-ID: <512E0DE4.10709@purplehaze.ch>
Date: Wed, 27 Feb 2013 14:45:08 +0100
From: Christian Affolter <c.affolter@purplehaze.ch>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: linux-media@vger.kernel.org
Subject: Re: Initial tuning data for upc cablecom Berne, Switzerland
References: <512D2C54.7010205@purplehaze.ch> <512DF217.3000305@schinagl.nl>
In-Reply-To: <512DF217.3000305@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oliver

>> Hi
>>
>> please find the initial tuning data for the Swiss cable provider "upc
>> cablecom" in Berne.
>>
>> I've added the data below to dvb-c/ch-Bern-upc-cablecom
>>
>> # upc cablecom
>> # Berne, Switzerland
>> # freq sr fec mod
>> C 426000000 6900000 NONE QAM64
> Thanks,
> 
> pushed in 5493eb3f5f7801cc409596de0e2d0edb499daf70

Thanks a lot, but watch out for the typo within the file name [1]:
The companies brand is spelled 'upc cablecom' [2] not 'UPC-Capblecom'.

Thanks again and best regards
Christian


[1]
http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-c/ch-Bern-UPC-Capblecom
[2] http://www.upc-cablecom.ch/en/b2c/about/ueberuns.htm
