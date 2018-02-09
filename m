Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34041 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751139AbeBIPnp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 10:43:45 -0500
Subject: Re: [PATCH 1/2] media: i2c: adv748x: Simplify regmap configuration
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1518024886-842-1-git-send-email-kbingham@kernel.org>
 <1518024886-842-2-git-send-email-kbingham@kernel.org>
 <20180209153915.GE7666@bigcity.dyn.berto.se>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <88e7c065-f2cb-f203-1f62-579760b7b6c2@ideasonboard.com>
Date: Fri, 9 Feb 2018 15:43:41 +0000
MIME-Version: 1.0
In-Reply-To: <20180209153915.GE7666@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 09/02/18 15:39, Niklas Söderlund wrote:
> Hi Kieran,
> 
> Thanks for your patch.
> 
> On 2018-02-07 17:34:45 +0000, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> The ADV748x has identical map configurations for each register map. The
>> duplication of each map can be simplified using a helper macro such that
>> each map is represented on a single line.
>>
>> Define ADV748X_REGMAP_CONF for this purpose and un-define after it's
>> use.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/i2c/adv748x/adv748x-core.c | 111 ++++++-------------------------
>>  1 file changed, 22 insertions(+), 89 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>> index fd92c9e4b519..71c69b816db2 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>> @@ -35,98 +35,31 @@
>>   * Register manipulation
>>   */
>>  
>> -static const struct regmap_config adv748x_regmap_cnf[] = {
>> -	{
>> -		.name			= "io",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "dpll",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "cp",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "hdmi",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "edid",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "repeater",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "infoframe",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "cec",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "sdp",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -
>> -	{
>> -		.name			= "txb",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> -
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> -	{
>> -		.name			= "txa",
>> -		.reg_bits		= 8,
>> -		.val_bits		= 8,
>> +#define ADV748X_REGMAP_CONF(n) \
>> +{ \
>> +	.name = n, \
>> +	.reg_bits = 8, \
>> +	.val_bits = 8, \
>> +	.max_register = 0xff, \
>> +	.cache_type = REGCACHE_NONE, \
>> +}
>>  
>> -		.max_register		= 0xff,
>> -		.cache_type		= REGCACHE_NONE,
>> -	},
>> +static const struct regmap_config adv748x_regmap_cnf[] = {
>> +	ADV748X_REGMAP_CONF("io"),
>> +	ADV748X_REGMAP_CONF("dpll"),
>> +	ADV748X_REGMAP_CONF("cp"),
>> +	ADV748X_REGMAP_CONF("hdmi"),
>> +	ADV748X_REGMAP_CONF("edid"),
>> +	ADV748X_REGMAP_CONF("repeater"),
>> +	ADV748X_REGMAP_CONF("infoframe"),
>> +	ADV748X_REGMAP_CONF("cec"),
>> +	ADV748X_REGMAP_CONF("sdp"),
>> +	ADV748X_REGMAP_CONF("txa"),
>> +	ADV748X_REGMAP_CONF("txb"),
>>  };
>>  
>> +#undef ADV748X_REGMAP_CONF
>> +
> 
> Why is this macro undefined here? It have a rather limited scope as it's 
> only local to this C file and it have a good prefix of ADV748X_ so 
> conflicts are highly unlikely. Is there something I'm missing?
> 
> Is it really customary to undefine helper macros like this once they are 
> used to populate the structure?

You are right - this is probably unnecessary, as the scope is limited to this
file. I guess I was trying to further highlight that the scope of the macro is
limited to this specific table as well.

Certainly likely to be required if this was a header, but it's not. So I'm happy
to remove...

> 
>>  static int adv748x_configure_regmap(struct adv748x_state *state, int region)
>>  {
>>  	int err;
>> -- 
>> 2.7.4
>>
> 
