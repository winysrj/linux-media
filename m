Return-path: <linux-media-owner@vger.kernel.org>
Received: from mognix.dark-green.com ([88.116.226.179]:63229 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZA2SHe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 13:07:34 -0500
Message-ID: <4981F064.7070407@dark-green.com>
Date: Thu, 29 Jan 2009 19:07:32 +0100
From: gimli <gimli@dark-green.com>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@tut.by>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Broken Tuning on Wintv Nova HD S2
References: <497F7117.9000607@dark-green.com> <200901291807.33531.liplianin@tut.by>
In-Reply-To: <200901291807.33531.liplianin@tut.by>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

your patch seems to work.

cu

Edgar (gimli) Hucek

Igor M. Liplianin schrieb:
> В сообщении от 27 January 2009 22:39:51 gimli написал(а):
>> Hi,
>>
>> the following changesets breaks Tuning to Vertical Transponders :
>>
>> http://mercurial.intuxication.org/hg/s2-liplianin/rev/1ca67881d96a
>> http://linuxtv.org/hg/v4l-dvb/rev/2cd7efb4cc19
>>
>> For example :
>>
>> DMAX;BetaDigital:12246:vC34M2O0S0:S19.2E:27500:511:512=deu:32:0:10101:1:109
>> 2:0
>>
>>
>> cu
>>
>> Edgar ( gimli ) Hucek
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> More likely not polarization, but hi band may broken.
> Anyway, please, try attached patch.
> 
> 

