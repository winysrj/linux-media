Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20169 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2LKQKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 11:10:00 -0500
Message-id: <50C75AD5.2040105@samsung.com>
Date: Tue, 11 Dec 2012 17:09:57 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 05/13] of: Add empty for_each_available_child_of_node()
 macro definition
References: <1355168499-5847-1-git-send-email-s.nawrocki@samsung.com>
 <1355168499-5847-6-git-send-email-s.nawrocki@samsung.com>
 <20121211085707.8D4F03E076D@localhost>
In-reply-to: <20121211085707.8D4F03E076D@localhost>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/11/2012 09:57 AM, Grant Likely wrote:
> On Mon, 10 Dec 2012 20:41:31 +0100, Sylwester Nawrocki <s.nawrocki@samsung.com> wrote:
>> Add this empty macro definition so users can be compiled without
>> excluding this macro call with preprocessor directives when CONFIG_OF
>> is disabled.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> What non-OF code is calling this function?

It is used in a driver [1] in an OF specific function. The patch is
in my second series that depends this one.
"[PATCH RFC 00/12] Device tree support for Exynos4 SoC camera drivers"

I thought it was better to add this empty macro definition rather
than using #ifdef CONFIG_OF in the code. However, in this case
the local variables would remain unused, so it's not really any
good solution. It just looked cumbersome to me to have in the code
something like

#ifdef CONFIG_OF
int func(void)
{
	int x;
	....
	return x;
}	
#else
#define func() (-ENOSYS)
#endif

After all it's not that bad and allows to compile out all OF code
when it's unused.

Please ignore patches 05..07/13, I'll drop them in next iteration.
And sorry for the noise.

[1] http://patchwork.linuxtv.org/patch/15852/

>> ---
>>  include/linux/of.h |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/include/linux/of.h b/include/linux/of.h
>> index 2fb0dbe..7df42cc 100644
>> --- a/include/linux/of.h
>> +++ b/include/linux/of.h
>> @@ -332,6 +332,9 @@ static inline bool of_have_populated_dt(void)
>>  #define for_each_child_of_node(parent, child) \
>>  	while (0)
>>  
>> +#define for_each_available_child_of_node(parent, child) \
>> +	while (0)
>> +
>>  static inline struct device_node *of_get_child_by_name(
>>  					const struct device_node *node,
>>  					const char *name)
>> -- 
>> 1.7.9.5

Thanks,
Sylwester

