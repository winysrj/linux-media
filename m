Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:36601 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760111Ab3B0PKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Feb 2013 10:10:48 -0500
Message-ID: <512E0DD1.8000705@schinagl.nl>
Date: Wed, 27 Feb 2013 14:44:49 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Geert Hedde Bosman <geert.hedde.bosman@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Please update DVB-T frequency list 'dvb-t/nl-All'
References: <512BD285.9010802@gmail.com> <512C91BC.4010306@schinagl.nl>
In-Reply-To: <512C91BC.4010306@schinagl.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26-02-13 11:43, Oliver Schinagl wrote:
> On 25-02-13 22:07, Geert Hedde Bosman wrote:
>> Hello,
>> in summer 2012 in the Netherlands major frequency changes took place 
>> in DVB-t broadcast. Some new frequencies were added as well. 
>> Therefore the frequency-file dvb/dvb-t/nl-All is no longer actual. 
>> Could someone (i believe Cristoph P. is one of the maintainers) 
>> please update this file? The website http://radio-tv-nederland.nl/ 
>> provides an up to date frequency list.
>> As an example: i had to add the following line to the file 'nl-All' 
>> to get the FTA tv-stations in the north of the Netherlands as it was 
>> missing:
>> T 674000000 8MHz 1/2 NONE QAM64 8k 1/4 NONE
> I'll go over the list and update all the frequencies. For me in the 
> south, the list seems to be still accurate ;)
>
> Expect a patch + push today/tomorrow.
Committed as 01b2cb337cfd3fb13fdc30454a6e292aded5e872

I have left out 726 MHz, since while reserved for DVB-T it is not in use 
yet (officially).
>>
>> regards
>> GHB
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

