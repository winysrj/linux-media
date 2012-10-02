Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51400 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab2JBAXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Oct 2012 20:23:18 -0400
Message-ID: <506A33DF.6080906@iki.fi>
Date: Tue, 02 Oct 2012 03:22:55 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH RFC] dvb: LNA implementation changes
References: <1349051751-11826-1-git-send-email-crope@iki.fi> <5068E7C1.4060602@iki.fi>
In-Reply-To: <5068E7C1.4060602@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping!

u.data is defined __u32. Does it mean we could only use unsigned values 
when DVB API v5 ?

If yes, I will change LNA according to that and use 32bit maximum as 
LNA_AUTO.

struct dtv_property {
	__u32 cmd;
	__u32 reserved[3];
	union {
		__u32 data;
		struct {
			__u8 data[32];
			__u32 len;
			__u32 reserved1[3];
			void *reserved2;
		} buffer;
	} u;
	int result;
} __attribute__ ((packed));


On 10/01/2012 03:45 AM, Antti Palosaari wrote:
> I added few comments for things what I was a little but unsure. Please
> comment.
>
> On 10/01/2012 03:35 AM, Antti Palosaari wrote:
>> * use dvb property cache
>> * implement get
>> * LNA_AUTO value changed
>>
>> Hans and Mauro proposed    use of cache implementation of get as they
>> were planning to extend LNA usage for analog side too.
>>
>> LNA_AUTO value was changed from (~0U) to INT_MIN as (~0U) resulted
>> only -1 which is waste of numeric range if need to extend that in
>> the future.
>>
>> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
>> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-core/dvb_frontend.c | 18 ++++++++++++++----
>>   drivers/media/dvb-core/dvb_frontend.h |  4 +++-
>>   drivers/media/usb/em28xx/em28xx-dvb.c |  9 +++++----
>>   include/linux/dvb/frontend.h          |  2 +-
>>   4 files changed, 23 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/media/dvb-core/dvb_frontend.c
>> b/drivers/media/dvb-core/dvb_frontend.c
>> index 8f58f24..246a3c5 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb-core/dvb_frontend.c
>> @@ -966,6 +966,8 @@ static int dvb_frontend_clear_cache(struct
>> dvb_frontend *fe)
>>           break;
>>       }
>>
>> +    c->lna = LNA_AUTO;
>> +
>>       return 0;
>>   }
>>
>> @@ -1054,6 +1056,8 @@ static struct dtv_cmds_h
>> dtv_cmds[DTV_MAX_COMMAND + 1] = {
>>       _DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_B, 0, 0),
>>       _DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_C, 0, 0),
>>       _DTV_CMD(DTV_ATSCMH_SCCC_CODE_MODE_D, 0, 0),
>> +
>> +    _DTV_CMD(DTV_LNA, 0, 0),
>>   };
>>
>>   static void dtv_property_dump(struct dvb_frontend *fe, struct
>> dtv_property *tvp)
>> @@ -1440,6 +1444,10 @@ static int dtv_property_process_get(struct
>> dvb_frontend *fe,
>>           tvp->u.data = fe->dtv_property_cache.atscmh_sccc_code_mode_d;
>>           break;
>>
>> +    case DTV_LNA:
>> +        tvp->u.data = c->lna;
>> +        break;
>> +
>>       default:
>>           return -EINVAL;
>>       }
>> @@ -1731,10 +1739,6 @@ static int dtv_property_process_set(struct
>> dvb_frontend *fe,
>>       case DTV_INTERLEAVING:
>>           c->interleaving = tvp->u.data;
>>           break;
>> -    case DTV_LNA:
>> -        if (fe->ops.set_lna)
>> -            r = fe->ops.set_lna(fe, tvp->u.data);
>> -        break;
>>
>>       /* ISDB-T Support here */
>>       case DTV_ISDBT_PARTIAL_RECEPTION:
>> @@ -1806,6 +1810,12 @@ static int dtv_property_process_set(struct
>> dvb_frontend *fe,
>>           fe->dtv_property_cache.atscmh_rs_frame_ensemble = tvp->u.data;
>>           break;
>>
>> +    case DTV_LNA:
>> +        c->lna = tvp->u.data;
>> +        if (fe->ops.set_lna)
>> +            r = fe->ops.set_lna(fe);
>> +        break;
>> +
>>       default:
>>           return -EINVAL;
>>       }
>> diff --git a/drivers/media/dvb-core/dvb_frontend.h
>> b/drivers/media/dvb-core/dvb_frontend.h
>> index 44a445c..5d25953 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.h
>> +++ b/drivers/media/dvb-core/dvb_frontend.h
>> @@ -303,7 +303,7 @@ struct dvb_frontend_ops {
>>       int (*dishnetwork_send_legacy_command)(struct dvb_frontend* fe,
>> unsigned long cmd);
>>       int (*i2c_gate_ctrl)(struct dvb_frontend* fe, int enable);
>>       int (*ts_bus_ctrl)(struct dvb_frontend* fe, int acquire);
>> -    int (*set_lna)(struct dvb_frontend *, int);
>> +    int (*set_lna)(struct dvb_frontend *);
>>
>>       /* These callbacks are for devices that implement their own
>>        * tuning algorithms, rather than a simple swzigzag
>> @@ -391,6 +391,8 @@ struct dtv_frontend_properties {
>>       u8            atscmh_sccc_code_mode_b;
>>       u8            atscmh_sccc_code_mode_c;
>>       u8            atscmh_sccc_code_mode_d;
>> +
>> +    int            lna;
>
> Is it reason or coincidence that all the other variables are unsigned here?
>
>>   };
>>
>>   struct dvb_frontend {
>> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c
>> b/drivers/media/usb/em28xx/em28xx-dvb.c
>> index 109474b..1166e8b 100644
>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
>> @@ -569,15 +569,16 @@ static void pctv_520e_init(struct em28xx *dev)
>>           i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
>>   };
>>
>> -static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe, int val)
>> +static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
>>   {
>> +    struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>>       struct em28xx *dev = fe->dvb->priv;
>>   #ifdef CONFIG_GPIOLIB
>>       struct em28xx_dvb *dvb = dev->dvb;
>>       int ret;
>>       unsigned long flags;
>>
>> -    if (val)
>> +    if (c->lna)
>>           flags = GPIOF_OUT_INIT_LOW;
>>       else
>>           flags = GPIOF_OUT_INIT_HIGH;
>> @@ -590,8 +591,8 @@ static int em28xx_pctv_290e_set_lna(struct
>> dvb_frontend *fe, int val)
>>
>>       return ret;
>>   #else
>> -    dev_warn(&dev->udev->dev, "%s: LNA control is disabled\n",
>> -            KBUILD_MODNAME);
>> +    dev_warn(&dev->udev->dev, "%s: LNA control is disabled (lna=%d)\n",
>> +            KBUILD_MODNAME, c->lna);
>>       return 0;
>>   #endif
>>   }
>> diff --git a/include/linux/dvb/frontend.h b/include/linux/dvb/frontend.h
>> index c12d452..6c97457 100644
>> --- a/include/linux/dvb/frontend.h
>> +++ b/include/linux/dvb/frontend.h
>> @@ -439,7 +439,7 @@ enum atscmh_rs_code_mode {
>>   };
>>
>>   #define NO_STREAM_ID_FILTER    (~0U)
>> -#define LNA_AUTO                (~0U)
>> +#define LNA_AUTO                INT_MIN
>
> That's (INT_MIN) again here because I used int in struct
> dtv_frontend_properties.
>
> I would like to use signed value that this could be extended later like
> use of attenuation.
>
>
>>
>>   struct dtv_cmds_h {
>>       char    *name;        /* A display name for debugging purposes */
>>
>
> And one question still. If we use signed value for LNA then value 0
> could be used as a LNA_AUTO. Like:
> -1 = LNA disabled
> 0 = LNA AUTO
> 1 = LNA enabled
>
>
> It is easy to change it now as it is new feature for 3.7. After that
> everything goes harder, so I really would like to get comments before
> -rc1 :)
>
> regards
> Antti
>


-- 
http://palosaari.fi/
