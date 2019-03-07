Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03EEC10F03
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DC4820840
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 10:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FzTYsQIW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfCGK1l (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:27:41 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38225 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfCGK1k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2019 05:27:40 -0500
Received: by mail-wm1-f66.google.com with SMTP id a188so8622850wmf.3;
        Thu, 07 Mar 2019 02:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6H3yADGNnbnt6pSPultKNdQyfxemFU0VTFw8p+6SX9Y=;
        b=FzTYsQIWa0qYeO2q1qZk8AgmTr5UjmiRC8nw/wggpTFYLdS1OFF5DACW5FqsBZzZou
         IXu2muCySAdSXGeYEFV0eAVUoKaohlbVGww625uxchAN4yq6fhVD4yn9DhgSvYFi7olj
         h6wX7NpsaeapijQXWoAt6ZE/FHbFm+CaRqdWZEoZSs+r5I6cSXJ2iYghyJ3HGm1TSPfh
         Eum1TDKv/CF8ENtjGNU+J9/TUFEQ/smSWVINexpucKZkQoXm5WP2BJlqGJN380LVrlGg
         VJfzF1l7bePGAOxqHRc7hiflhnQ+dDe15wwHMSKQS+Apwb+548m8g/60B7NRnavMZyPL
         Q6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6H3yADGNnbnt6pSPultKNdQyfxemFU0VTFw8p+6SX9Y=;
        b=Z2KY8yL5to9qKXa6z2GJ9v8ONwZJlLcC0eHqmv1IgWOPPZIEePG2mQPA8miwzqGgmK
         TPXVGyf4ovN9WMsJHUzfDgiU6Yj9tSLAj+bY0dKX1mxASCMr+Wu/vUoU7xjt6gZPyHwL
         V6Sz+dPh5TRDjvdOFH+D7PD+UTgkT5+O1AzxnDmDe1vz3YSU7AC8YpWC1rjwpWquWkm4
         nkTpLPmzZcXMnTi7Zznbo25Wkg30DrbKEMSSmGckpw+sV7cPl+HaGsaaZAtA6tsyAGX3
         zEK7rGhD0Z+a/n2aIXLLdWFbOfvv6tzYv63u9nkUgmhucdlUBKrl+pKeE61/H/wveaUW
         iZsQ==
X-Gm-Message-State: APjAAAV32kXL8PTXv9kDjmhp+Re5ry8NbigpjowVec6Ln8ukYSduihFN
        w4lprMy3TLZ42BPEdc888AchEpD/
X-Google-Smtp-Source: APXvYqxNucetnmXjTPzzuxmcpeNA5ipdyQxLdxCeTEzzSdPAUhKvmQLCJttzJCj1v1R+W8dPGwb4gg==
X-Received: by 2002:a1c:7f15:: with SMTP id a21mr4784756wmd.27.1551954458260;
        Thu, 07 Mar 2019 02:27:38 -0800 (PST)
Received: from [192.168.19.12] (host86-147-153-76.range86-147.btcentralplus.com. [86.147.153.76])
        by smtp.googlemail.com with ESMTPSA id e7sm7280237wrw.35.2019.03.07.02.27.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 02:27:37 -0800 (PST)
Subject: Re: [PATCH v3 12/31] media: entity: Add an iterator helper for
 connected pads
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20190305185150.20776-1-jacopo+renesas@jmondi.org>
 <20190305185150.20776-13-jacopo+renesas@jmondi.org>
 <20190307100924.4iuabzet67ttgk2p@paasikivi.fi.intel.com>
From:   Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <9f07ed66-b67b-500e-1faf-7e9c31447fd1@gmail.com>
Date:   Thu, 7 Mar 2019 10:27:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <20190307100924.4iuabzet67ttgk2p@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 07/03/2019 10:09, Sakari Ailus wrote:
> Hi Jacopo,
> 
> On Tue, Mar 05, 2019 at 07:51:31PM +0100, Jacopo Mondi wrote:
>> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
>> Add a helper macro for iterating over pads that are connected through
>> enabled routes. This can be used to find all the connected pads within an
>> entity, for instance starting from the pad which has been obtained during
>> the graph walk.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>
>> - Make __media_entity_next_routed_pad() return NULL and adjust the
>>    iterator to handle that
>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> ---
>>   include/media/media-entity.h | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>> index 205561545d7e..82f0bdf2a6d1 100644
>> --- a/include/media/media-entity.h
>> +++ b/include/media/media-entity.h
>> @@ -936,6 +936,33 @@ __must_check int media_graph_walk_init(
>>   bool media_entity_has_route(struct media_entity *entity, unsigned int pad0,
>>   			    unsigned int pad1);
>>   
>> +static inline struct media_pad *__media_entity_next_routed_pad(
>> +	struct media_pad *start, struct media_pad *iter)
>> +{
>> +	struct media_entity *entity = start->entity;
>> +
>> +	while (iter < &entity->pads[entity->num_pads] &&
>> +	       !media_entity_has_route(entity, start->index, iter->index))
>> +		iter++;
>> +
>> +	return iter == &entity->pads[entity->num_pads] ? NULL : iter;
> 
> Could you use iter <= ...?
> 
> It doesn't seem to matter here, but it'd seem safer to change the check.
> 

How about something like...

for (; iter < &entity->pads[entity->num_pads]; iter++)
     if (media_entity_has_route(entity, start->index, iter->index))
         return iter;

return NULL;

Regards,
Ian

>> +}
>> +
>> +/**
>> + * media_entity_for_each_routed_pad - Iterate over entity pads connected by routes
>> + *
>> + * @start: The stating pad
>> + * @iter: The iterator pad
>> + *
>> + * Iterate over all pads connected through routes from a given pad
>> + * within an entity. The iteration will include the starting pad itself.
>> + */
>> +#define media_entity_for_each_routed_pad(start, iter)			\
>> +	for (iter = __media_entity_next_routed_pad(			\
>> +		     start, (start)->entity->pads);			\
>> +	     iter != NULL;						\
>> +	     iter = __media_entity_next_routed_pad(start, iter + 1))
>> +
>>   /**
>>    * media_graph_walk_cleanup - Release resources used by graph walk.
>>    *
> 
