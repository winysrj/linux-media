Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49202 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbbESQC0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 12:02:26 -0400
Message-ID: <555B5E32.9060301@iki.fi>
Date: Tue, 19 May 2015 19:00:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	Federico Simoncelli <fsimonce@redhat.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Takashi Iwai <tiwai@suse.de>,
	Amber Thrall <amber.rose.thrall@gmail.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/2] drivers: Simplify the return code
References: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>	<0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>	<a24b23db60ffee5cb32403d7c8cacd25b13f4510.1432033220.git.mchehab@osg.samsung.com>	<577085828.1080862.1432037155994.JavaMail.zimbra@redhat.com> <20150519141731.78744f2f@wiggum>
In-Reply-To: <20150519141731.78744f2f@wiggum>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/19/2015 03:17 PM, Michael Büsch wrote:
> On Tue, 19 May 2015 08:05:56 -0400 (EDT)
> Federico Simoncelli <fsimonce@redhat.com> wrote:
>>> diff --git a/drivers/media/dvb-frontends/lgs8gxx.c
>>> b/drivers/media/dvb-frontends/lgs8gxx.c
>>> index 3c92f36ea5c7..9b0166cdc7c2 100644
>>> --- a/drivers/media/dvb-frontends/lgs8gxx.c
>>> +++ b/drivers/media/dvb-frontends/lgs8gxx.c
>>> @@ -544,11 +544,7 @@ static int lgs8gxx_set_mpeg_mode(struct lgs8gxx_state
>>> *priv,
>>>   	t |= clk_pol ? TS_CLK_INVERTED : TS_CLK_NORMAL;
>>>   	t |= clk_gated ? TS_CLK_GATED : TS_CLK_FREERUN;
>>>
>>> -	ret = lgs8gxx_write_reg(priv, reg_addr, t);
>>> -	if (ret != 0)
>>> -		return ret;
>>> -
>>> -	return 0;
>>> +	return lgs8gxx_write_reg(priv, reg_addr, t);
>>>   }
>>
>> Personally I prefer the current style because it's more consistent with all
>> the other calls in the same function (return ret when ret != 0).
>>
>> It also allows you to easily add/remove calls without having to deal with
>> the last special case return my_last_fun_call(...).
>>
>> Anyway it's not a big deal, I think it's your call.
>
>
> I agree. I also prefer the current style for these reasons. The compiler will also generate the same code in both cases.
> I don't think it really simplifies the code.
> But if you really insist on doing this change, go for it. You get my ack for fc0011


I am also against that kind of simplifications. Even it reduces line or 
two, it makes code more inconsistent, which means you have to make extra 
thinking when reading that code. I prefer similar repeating patterns as 
much as possible.

This is how I do it usually, even there is that extra last goto.

	ret = write_reg();
	if (ret)
		goto err;

	ret = write_reg();
	if (ret)
		goto err;
err:
	return ret;
};

regards
Antti

-- 
http://palosaari.fi/
