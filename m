Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65486 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759473Ab1IIQq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 12:46:57 -0400
Received: by eyx24 with SMTP id 24so1463223eyx.19
        for <linux-media@vger.kernel.org>; Fri, 09 Sep 2011 09:46:56 -0700 (PDT)
Message-ID: <4E6A414A.8070207@gmail.com>
Date: Fri, 09 Sep 2011 18:39:38 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	"Netagunte, Nagabhushana" <nagabhushana.netagunte@ti.com>
Subject: Re: [PATCH v2 4/8] davinci: vpfe: add support for CCDC hardware for
 dm365
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com> <1314630439-1122-5-git-send-email-manjunath.hadli@ti.com> <4E5FF7BC.3040108@gmail.com> <B85A65D85D7EB246BE421B3FB0FBB593025743F3C9@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593025743F3C9@dbde02.ent.ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Manju,

On 09/09/2011 03:30 PM, Hadli, Manjunath wrote:
> Thank you for these comments too.
> 
> My responses inlined.
> -Manju

Thanks for addressing my comments.

> 
> On Fri, Sep 02, 2011 at 02:53:08, Sylwester Nawrocki wrote:
...
>>> +/**
>>> + * ccdc float type S8Q8/U8Q8
>>> + */
>>> +struct ccdc_float_8 {
>>> +	/* 8 bit integer part */
>>> +	unsigned char integer;
>>> +	/* 8 bit decimal part */
>>> +	unsigned char decimal;
>>> +};
>>
>> Isn't it better to use explicit width type, like u8, u16, etc. ?
>> Then we could just have:
>>
>> +struct ccdc_float_8 {
>> +	u8 integer;
>> +	u8 decimal;
>> +};
>>
> This is an interface header which is also used by apps. So we have
> kept it as unsigned char. Any suggestions on that?

OK, sorry, I haven't noticed that. Anyway, I think you could use the
double underscore prefixed types (__[u,s][8,32,16]), from linux/types.h.
They are widely used in in linux/videodev2.h for instance.


--
Regards,
Sylwester
