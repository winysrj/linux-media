Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:36195 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760040Ab3B0Oci (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 09:32:38 -0500
Received: from [10.2.0.180] (unknown [10.2.0.180])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by 7of9.schinagl.nl (Postfix) with ESMTPSA id 9137C2221D
	for <linux-media@vger.kernel.org>; Wed, 27 Feb 2013 15:32:34 +0100 (CET)
Message-ID: <512E04DE.2040305@schinagl.nl>
Date: Wed, 27 Feb 2013 14:06:38 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Initial tuning data for upc cablecom Berne, Switzerland
References: <512D2C54.7010205@purplehaze.ch> <512DF217.3000305@schinagl.nl> <512E0DE4.10709@purplehaze.ch>
In-Reply-To: <512E0DE4.10709@purplehaze.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27-02-13 14:45, Christian Affolter wrote:
> Hi Oliver
>
>>> Hi
>>>
>>> please find the initial tuning data for the Swiss cable provider "upc
>>> cablecom" in Berne.
>>>
>>> I've added the data below to dvb-c/ch-Bern-upc-cablecom
>>>
>>> # upc cablecom
>>> # Berne, Switzerland
>>> # freq sr fec mod
>>> C 426000000 6900000 NONE QAM64
>> Thanks,
>>
>> pushed in 5493eb3f5f7801cc409596de0e2d0edb499daf70
> Thanks a lot, but watch out for the typo within the file name [1]:
> The companies brand is spelled 'upc cablecom' [2] not 'UPC-Capblecom'.
>
I will adjust this immediatly the typo (do'h cablecom, capcom!) and the 
capitisation. It appeared that it was lazy capitalization from your end 
for that I apologize. I wrongfully assumed since UPC here in NL is in 
caps, it should have been there as well. I'll lower the ch one.

> Thanks again and best regards
> Christian
>
>
> [1]
> http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-c/ch-Bern-UPC-Capblecom
> [2] http://www.upc-cablecom.ch/en/b2c/about/ueberuns.htm
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

