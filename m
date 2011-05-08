Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:48101 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1EHWFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 18:05:09 -0400
Message-ID: <4DC71390.404@linuxtv.org>
Date: Mon, 09 May 2011 00:05:04 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] Documentation: Update to include DVB-T2 additions
References: <4DC417DA.5030107@redhat.com>	 <1304869873-9974-7-git-send-email-steve@stevekerrison.com>	 <4DC6C2DC.9010102@redhat.com> <1304881988.2920.18.camel@ares>
In-Reply-To: <1304881988.2920.18.camel@ares>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 05/08/2011 09:13 PM, Steve Kerrison wrote:
> Hi Mauro
> 
>> +		<para>3) DVB-T specifies 2K and 8K as valid sizes.</para>
>>> +		<para>4) DVB-T2 specifies 1K, 2K, 4K, 8K, 16K and 32K.</para>
>>
>> It makes sense to add here that ISDB-T specifies 2K, 4K and 8K.
>> (yeah, sorry, it is my fault that I didn't notice it before ;) )
> 
> Actually note 1) in that list declares the sizes supported by ISDB-T;
> but the patch doesn't show it. So there is no blame to assign :)
> 
>> -#define DTV_MAX_COMMAND                         DTV_ISDBS_TS_ID
>>> +#define DTV_DVBT2_PLP_ID	43
>>> +
>>
>> Please document the PLP_ID as well. Just like ISDB-T, the best seems to
>> create a section with DVB-T2 specific parameters, and add this one there,
>> explaining its meaning.
> 
> I have created a section for DVB-T2 parameters. It's within the main
> ISDB-T section. If that's not appropriate I guess it can be hauled out
> as it grows. However, much like Antti, I don't know much about PLP or
> the other features of the T2 specification, so cannot contribute a great
> deal yet. PLP_ID isn't used by the cxd2820r driver - it's simply
> specified in Andreas' API patch.

In DVB-T2, each TS is contained in a 'Physical Layer Pipe' (PLP).
Multiple PLPs with individual tuning parameters may be combined on a
single transmitter frequency.

I don't know whether multiple PLP mode is or will be used in any
country. If no PLP ID or an invalid PLP ID is specified, the behaviour
of a demod may be undefined, i.e. it may select a random PLP or fail to
tune.

In DVB-SI, the PLP ID is carried within the T2 delivery system descriptor.

Regards,
Andreas
