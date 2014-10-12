Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:51916 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaJLKwq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Oct 2014 06:52:46 -0400
Received: by mail-lb0-f175.google.com with SMTP id u10so5081507lbd.6
        for <linux-media@vger.kernel.org>; Sun, 12 Oct 2014 03:52:45 -0700 (PDT)
Received: from Olli-Salonens-MacBook.local (87-93-228-250.bb.dnainternet.fi. [87.93.228.250])
        by mx.google.com with ESMTPSA id w8sm3503935lal.41.2014.10.12.03.52.44
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 12 Oct 2014 03:52:44 -0700 (PDT)
Message-ID: <543A5D7B.8020401@iki.fi>
Date: Sun, 12 Oct 2014 13:52:43 +0300
From: Olli Salonen <olli.salonen@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] dvbsky: add option to disable IR receiver
References: <1413108191-32510-1-git-send-email-olli.salonen@iki.fi> <1413108191-32510-4-git-send-email-olli.salonen@iki.fi> <543A540A.2010507@iki.fi>
In-Reply-To: <543A540A.2010507@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.10.2014 13:12, Antti Palosaari wrote:
>>   static int dvbsky_get_rc_config(struct dvb_usb_device *d, struct 
>> dvb_usb_rc *rc)
>>   {
>> +    if (dvb_usb_dvbsky_disable_rc)
>> +        return 0;
>> +
>> +    rc->map_name       = RC_MAP_DVBSKY;
>>       rc->allowed_protos = RC_BIT_RC5;
>>       rc->query          = dvbsky_rc_query;
>>       rc->interval       = 300;
>> @@ -450,7 +458,7 @@ static struct dvb_usb_device_properties 
>> dvbsky_s960_props = {
>>
>>   static const struct usb_device_id dvbsky_id_table[] = {
>>       { DVB_USB_DEVICE(0x0572, 0x6831,
>> -        &dvbsky_s960_props, "DVBSky S960/S860", RC_MAP_DVBSKY) },
>> +        &dvbsky_s960_props, "DVBSky S960/S860", NULL) },
>
> Why you removed default keytable too?
>
I initially thought that it would make sense to set all RC related 
parameters in the get_rc_config function. Of couse I could set 
RC_MAP_DVBSKY as default map and then set it to NULL only if the remote 
controller is disabled. Now that I think of it, it's probably better to 
do it this way. The next DVBSky OEM device might come with another 
remote controller, and we don't want to implement the map selection 
logic into the get_rc_config.

In general I did not see many modules with IR disable function. Is this 
the right way to implement it? I noticed that dvb-usb-v2 had an option 
to disable IR polling, but that will disable it for all dvb-usb-v2 
modules. I have 2 adapters in my HTPC setup and want to disable the IR 
only for the device that uses the dvbsky module.

-olli
