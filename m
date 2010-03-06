Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47494 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0CFOnx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 09:43:53 -0500
Message-ID: <4B926A25.3020801@infradead.org>
Date: Sat, 06 Mar 2010 11:43:49 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-media@vger.kernel.org, Henrik Kurelid <henrik@kurelid.se>
Subject: Re: [PATCH] firedtv: add parameter to fake ca_system_ids in CA_INFO
References: <tkrat.dc97d52c76a2dc07@s5r6.in-berlin.de> <tkrat.a8cdf995cdc06e83@s5r6.in-berlin.de> <4B925E25.2070105@infradead.org> <4B92623C.2060302@s5r6.in-berlin.de>
In-Reply-To: <4B92623C.2060302@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stefan Richter wrote:
> Mauro Carvalho Chehab wrote:
>> Stefan Richter wrote:
>>
>>> The Digital Everywhere firmware have the shortcoming that ca_info_enq and
>>> ca_info are not supported. This means that we can never retrieve the correct
>>> ca_system_id to present in the CI message CA_INFO. Currently the driver uses
>>> the application id retrieved using app_info_req and app_info, but this id
>>> only match the correct ca_system_id as given in ca_info in some cases.
>>> This patch adds a parameter to the driver in order for the user to override
>>> what will be returned in the CA_INFO CI message. Up to four ca_system_ids can
>>> be specified.
>>> This is needed for users with CAMs that have different manufacturer id and
>>> ca_system_id and that uses applications that take this into account, like
>>> MythTV.
>> This seems an ugly workaround. The better seems to patch MythTV to accept a different
>> CAM.
> 
> Ugly it is, for sure.  Can't comment on application-level solutions; if
> thats the proper layer at which to address this, then that would be
> preferable of course.

>From the report, this seems to be a requirement at application level. So, the fix should
be there.

Henrik, is there any reason why not patching MythTV?

> 
>>> +static int num_fake_ca_system_ids;
>> ...
>>> +		for (i = 0; i < num_fake_ca_system_ids; i++) {
>>> +			app_info[4 + i * 2] =
>>> +				(fake_ca_system_ids[i] >> 8) & 0xff;
>> ...
>>
>> NAK. If someone put an arbitrary high value for num_fake_ca_system_id's, it will write outside
>> the app_info array space, as the num_fake_ca_system_ids is not validated against the size
>> of app_info.
> 
> That's what I thought at first look at the patch too, but then I noticed
> that inlcude/linux/moduleparam.h and kernel/params.c properly track
> kparam_arry.max = ARRAY_SIZE(array).
> http://lxr.linux.no/#linux+v2.6.33/include/linux/moduleparam.h#L62
> http://lxr.linux.no/#linux+v2.6.33/include/linux/moduleparam.h#L213
> http://lxr.linux.no/#linux+v2.6.33/kernel/params.c#L351
> http://lxr.linux.no/#linux+v2.6.33/kernel/params.c#L296
> 
> So no danger here.
> 
>> Also, it makes no sense a negative value for this parameter.
> 
> I already posted an updated version of the patch which correctly defines
> num_fake_ca_system_ids as an unsigned long.

Ok. As app_info is char [256] (from ca_info::msg field), and kernel module avoids
the size of the array to be bigger than 4 (the sizeof the array), that's should be ok.

-- 

Cheers,
Mauro
