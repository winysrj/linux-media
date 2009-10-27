Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:51448 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbZJ0LmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 07:42:24 -0400
Received: by pzk26 with SMTP id 26so32831pzk.4
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2009 04:42:29 -0700 (PDT)
Message-ID: <4AE6DCA2.4070802@gmail.com>
Date: Tue, 27 Oct 2009 19:42:26 +0800
From: KS Ng <ksnggm@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: failure to submit first post
References: <4AE4541D.7060206@gmail.com>	<4AE5A2F3.1060504@gmail.com> <20091027081155.05927ad4@pedra.chehab.org>
In-Reply-To: <20091027081155.05927ad4@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for your attention! I also believe packets under tuner_init_pkts 
constitute the firmware of the device. I'll see how to construct a 
firmware file instead of coding them inline, and I'll re-submit once 
I've figured that out.

Cheers,
K.S. Ng

Mauro Carvalho Chehab wrote:
> Em Mon, 26 Oct 2009 21:24:03 +0800
> KS Ng <ksnggm@gmail.com> escreveu:
>
>   
>> This is a resend with the patch attached.
>>
>> KS Ng wrote:
>>     
>>> Hi,
>>>
>>> I've registered to linux-media mailing list a couple of days ago and 
>>> attempted to do my first posting yesterday with subject "Support for 
>>> Magicpro proHDTV Dual DMB-TH adapter". However I can't see my posting 
>>> even though I've replied to the email requesting confirmation.
>>>
>>> Would you please kindly have a look!
>>>       
>
> Please take a look at:
> 	http://linuxtv.org/hg/v4l-dvb/raw-file/tip/README.patches
>
> for some comments about how to submit a patch.
>
> Basically, you'll need to send a patch with a short description at the subject,
> a more complete description at the body and add your Signed-off-by: there.
>
> Also, please run checkpatch before submitting it, since it will point you the CodingStyle
> troubles that your code have. There are several coding styles there, being harder for people
> to analyse your code.
>
> In the case of tuner_init_pkts, is this a firmware or just register sets? If it
> is a firmware, it should be split from the code, due to legal issues.
> Basically, some lawyers believe that, if you distribute a firmware inside of
> the source code of a GPL'd code, you're bound to distribute also the firmware
> source code, due to GPL.
>
> Cheers,
> Mauro.
>
>   
>>> Thanks,
>>> K.S. Ng
>>>
>>> email: ksnggm@gmail.com
>>>       
>
>
>
>
> Cheers,
> Mauro
>   

