Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53492 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaLROlb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 09:41:31 -0500
Message-ID: <5492E798.5020409@iki.fi>
Date: Thu, 18 Dec 2014 16:41:28 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC HACK] rtl2832: implement own lock for RegMap
References: <1418898586-8167-1-git-send-email-crope@iki.fi> <20141218092109.3833f38d@recife.lan>
In-Reply-To: <20141218092109.3833f38d@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2014 01:21 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 18 Dec 2014 12:29:46 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Introduce own lock to silence locdep warning. I suspect lockdep checks
>> make wrong decision when two similar name (&map->mutex) locks were
>> taken recursively, even those are different mutexes in a two different
>> driver. After that patch, functionality remains same, but mutex names
>> are different.
>
> Please do not add a hack just to silence a lockdep warning.
>
> Please take a look at: Documentation/locking/lockdep-design.txt
>
> There are some documentation there about the usage of nested locks and
> how to avoid lockdep to complain.

I cannot see any way how those lockdep things could be used on my driver 
as problematic lock itself is located inside RegMap. I think it is 
RegMap which needs some special lockdep things in order to allow nested 
locking of different instances.

So I think demod I2C adapter is good place for that kind of hack until 
better solution is find. Defining own RegMap lock here in I2C repeater 
allows all the clients be hack free using default RegMap lock.

regards
Antti


>
> Regards,
> Mauro
>
>>
>> =============================================
>> [ INFO: possible recursive locking detected ]
>> 3.18.0-rc4+ #4 Tainted: G           O
>> ---------------------------------------------
>> kdvb-ad-0-fe-0/2814 is trying to acquire lock:
>>   (&map->mutex){+.+.+.}, at: [<ffffffff814ec90f>] regmap_lock_mutex+0x2f/0x40
>>
>> but task is already holding lock:
>>   (&map->mutex){+.+.+.}, at: [<ffffffff814ec90f>] regmap_lock_mutex+0x2f/0x40
>>
>> other info that might help us debug this:
>>   Possible unsafe locking scenario:
>>         CPU0
>>         ----
>>    lock(&map->mutex);
>>    lock(&map->mutex);
>>
>>   *** DEADLOCK ***
>>   May be due to missing lock nesting notation
>> 1 lock held by kdvb-ad-0-fe-0/2814:
>>   #0:  (&map->mutex){+.+.+.}, at: [<ffffffff814ec90f>] regmap_lock_mutex+0x2f/0x40
>>
>> stack backtrace:
>> CPU: 3 PID: 2814 Comm: kdvb-ad-0-fe-0 Tainted: G           O 3.18.0-rc4+ #4
>> Hardware name: System manufacturer System Product Name/M5A78L-M/USB3, BIOS 2001    09/11/2014
>>   0000000000000000 00000000410c8772 ffff880293af3868 ffffffff817a6f82
>>   0000000000000000 ffff8800b3462be0 ffff880293af3968 ffffffff810e7f94
>>   ffff880293af3888 00000000410c8772 ffffffff82dfee60 ffffffff81ab8f89
>> Call Trace:
>>   [<ffffffff817a6f82>] dump_stack+0x4e/0x68
>>   [<ffffffff810e7f94>] __lock_acquire+0x1ea4/0x1f50
>>   [<ffffffff810e2a7d>] ? trace_hardirqs_off+0xd/0x10
>>   [<ffffffff817b01f3>] ? _raw_spin_lock_irqsave+0x83/0xa0
>>   [<ffffffff810e13e6>] ? up+0x16/0x50
>>   [<ffffffff810e2a7d>] ? trace_hardirqs_off+0xd/0x10
>>   [<ffffffff817af8bf>] ? _raw_spin_unlock_irqrestore+0x5f/0x70
>>   [<ffffffff810e9069>] lock_acquire+0xc9/0x170
>>   [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
>>   [<ffffffff817ab50e>] mutex_lock_nested+0x7e/0x430
>>   [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
>>   [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
>>   [<ffffffff817a530b>] ? printk+0x70/0x86
>>   [<ffffffff8110d9e8>] ? mod_timer+0x168/0x240
>>   [<ffffffff814ec90f>] regmap_lock_mutex+0x2f/0x40
>>   [<ffffffff814f08d9>] regmap_update_bits+0x29/0x60
>>   [<ffffffffa03e9778>] rtl2832_select+0x38/0x70 [rtl2832]
>>   [<ffffffffa039b03d>] i2c_mux_master_xfer+0x3d/0x90 [i2c_mux]
>>   [<ffffffff815da493>] __i2c_transfer+0x73/0x2e0
>>   [<ffffffff815dbaba>] i2c_transfer+0x5a/0xc0
>>   [<ffffffff815dbb6e>] i2c_master_send+0x4e/0x70
>>   [<ffffffffa03ff25a>] regmap_i2c_write+0x1a/0x50 [regmap_i2c]
>>   [<ffffffff817ab713>] ? mutex_lock_nested+0x283/0x430
>>   [<ffffffff814f06b2>] _regmap_raw_write+0x862/0x880
>>   [<ffffffff814ec90f>] ? regmap_lock_mutex+0x2f/0x40
>>   [<ffffffff814f0744>] _regmap_bus_raw_write+0x74/0xa0
>>   [<ffffffff814ef3d2>] _regmap_write+0x92/0x140
>>   [<ffffffff814f0b7b>] regmap_write+0x4b/0x70
>>   [<ffffffffa032b090>] ? dvb_frontend_release+0x110/0x110 [dvb_core]
>>   [<ffffffffa05141d4>] e4000_init+0x34/0x210 [e4000]
>>   [<ffffffffa032a029>] dvb_frontend_init+0x59/0xc0 [dvb_core]
>>   [<ffffffff810bde30>] ? finish_task_switch+0x80/0x180
>>   [<ffffffff810bddf2>] ? finish_task_switch+0x42/0x180
>>   [<ffffffffa032b116>] dvb_frontend_thread+0x86/0x7b0 [dvb_core]
>>   [<ffffffff817a9203>] ? __schedule+0x343/0x930
>>   [<ffffffffa032b090>] ? dvb_frontend_release+0x110/0x110 [dvb_core]
>>   [<ffffffff810b826b>] kthread+0x10b/0x130
>>   [<ffffffff81020099>] ? sched_clock+0x9/0x10
>>   [<ffffffff810b8160>] ? kthread_create_on_node+0x250/0x250
>>   [<ffffffff817b063c>] ret_from_fork+0x7c/0xb0
>>   [<ffffffff810b8160>] ? kthread_create_on_node+0x250/0x250
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/dvb-frontends/rtl2832.c      | 49 +++++++++++++++++++++++-------
>>   drivers/media/dvb-frontends/rtl2832_priv.h |  2 ++
>>   2 files changed, 40 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
>> index f44dc50..2ee5bcf 100644
>> --- a/drivers/media/dvb-frontends/rtl2832.c
>> +++ b/drivers/media/dvb-frontends/rtl2832.c
>> @@ -1028,6 +1028,31 @@ static int rtl2832_regmap_gather_write(void *context, const void *reg,
>>   	return 0;
>>   }
>>
>> +/*
>> + * FIXME: Implement own RegMap locking in order to silence lockdep recursive
>> + * lock warning. That happens when RegMap I2C client calls I2C mux adapter,
>> + * which leads demod I2C repeater enable via demod RegMap. Operation takes two
>> + * RegMap locks recursively - but those are different RegMap instances in a two
>> + * different I2C drivers, so it should be deadlock.
>> + */
>> +static void rtl2832_regmap_lock(void *__dev)
>> +{
>> +	struct rtl2832_dev *dev = __dev;
>> +	struct i2c_client *client = dev->client;
>> +
>> +	dev_dbg(&client->dev, "\n");
>> +	mutex_lock(&dev->regmap_mutex);
>> +}
>> +
>> +static void rtl2832_regmap_unlock(void *__dev)
>> +{
>> +	struct rtl2832_dev *dev = __dev;
>> +	struct i2c_client *client = dev->client;
>> +
>> +	dev_dbg(&client->dev, "\n");
>> +	mutex_unlock(&dev->regmap_mutex);
>> +}
>> +
>>   static struct dvb_frontend *rtl2832_get_dvb_frontend(struct i2c_client *client)
>>   {
>>   	struct rtl2832_dev *dev = i2c_get_clientdata(client);
>> @@ -1186,15 +1211,6 @@ static int rtl2832_probe(struct i2c_client *client,
>>   			.range_max        = 5 * 0x100,
>>   		},
>>   	};
>> -	static const struct regmap_config regmap_config = {
>> -		.reg_bits    =  8,
>> -		.val_bits    =  8,
>> -		.volatile_reg = rtl2832_volatile_reg,
>> -		.max_register = 5 * 0x100,
>> -		.ranges = regmap_range_cfg,
>> -		.num_ranges = ARRAY_SIZE(regmap_range_cfg),
>> -		.cache_type = REGCACHE_RBTREE,
>> -	};
>>
>>   	dev_dbg(&client->dev, "\n");
>>
>> @@ -1218,8 +1234,19 @@ static int rtl2832_probe(struct i2c_client *client,
>>   	INIT_DELAYED_WORK(&dev->i2c_gate_work, rtl2832_i2c_gate_work);
>>   	INIT_DELAYED_WORK(&dev->stat_work, rtl2832_stat_work);
>>   	/* create RegMap */
>> +	mutex_init(&dev->regmap_mutex);
>> +	dev->regmap_config.reg_bits =  8,
>> +	dev->regmap_config.val_bits =  8,
>> +	dev->regmap_config.lock = rtl2832_regmap_lock,
>> +	dev->regmap_config.unlock = rtl2832_regmap_unlock,
>> +	dev->regmap_config.lock_arg = dev,
>> +	dev->regmap_config.volatile_reg = rtl2832_volatile_reg,
>> +	dev->regmap_config.max_register = 5 * 0x100,
>> +	dev->regmap_config.ranges = regmap_range_cfg,
>> +	dev->regmap_config.num_ranges = ARRAY_SIZE(regmap_range_cfg),
>> +	dev->regmap_config.cache_type = REGCACHE_RBTREE,
>>   	dev->regmap = regmap_init(&client->dev, &regmap_bus, client,
>> -				  &regmap_config);
>> +				  &dev->regmap_config);
>>   	if (IS_ERR(dev->regmap)) {
>>   		ret = PTR_ERR(dev->regmap);
>>   		goto err_kfree;
>> @@ -1232,7 +1259,7 @@ static int rtl2832_probe(struct i2c_client *client,
>>
>>   	/* create muxed i2c adapter for demod tuner bus */
>>   	dev->i2c_adapter_tuner = i2c_add_mux_adapter(i2c, &i2c->dev, dev,
>> -			0, 0, 0, rtl2832_select, rtl2832_deselect);
>> +			0, 1, 0, rtl2832_select, rtl2832_deselect);
>>   	if (dev->i2c_adapter_tuner == NULL) {
>>   		ret = -ENODEV;
>>   		goto err_regmap_exit;
>> diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
>> index 9ff4f65..c3a922c 100644
>> --- a/drivers/media/dvb-frontends/rtl2832_priv.h
>> +++ b/drivers/media/dvb-frontends/rtl2832_priv.h
>> @@ -33,6 +33,8 @@
>>   struct rtl2832_dev {
>>   	struct rtl2832_platform_data *pdata;
>>   	struct i2c_client *client;
>> +	struct mutex regmap_mutex;
>> +	struct regmap_config regmap_config;
>>   	struct regmap *regmap;
>>   	struct i2c_adapter *i2c_adapter_tuner;
>>   	struct dvb_frontend fe;

-- 
http://palosaari.fi/
