Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32944 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbcFITOR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 15:14:17 -0400
Subject: Re: dvb-core: how should i2c subdev drivers be attached?
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
 <20160609122449.5cfc16cc@recife.lan>
 <07669546-908f-f81c-26e5-af7b720229b3@iki.fi>
 <20160609131813.710e1ab2@recife.lan>
 <f89f96f0-40a3-6e50-5d83-0cfaf50e8089@iki.fi>
 <20160609153015.108e4d98@recife.lan>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <a67edaab-4da2-6ccf-9b2a-08f95cc1072e@iki.fi>
Date: Thu, 9 Jun 2016 22:14:12 +0300
MIME-Version: 1.0
In-Reply-To: <20160609153015.108e4d98@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2016 09:30 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 9 Jun 2016 19:38:04 +0300
> Antti Palosaari <crope@iki.fi> escreveu:

>>> The V4L2 core handles everything that it is needed for it to work, and
>>> no extra code is needed to do module_put() or i2c_unregister_device().
>>
>> That example attachs 2 I2C drivers, as your example only 1.
>
> Well, on V4L2, 2 I2C drivers, two statements.
>
>> Also it
>> populates all the config to platform data on both I2C driver.
>
> Yes, this is annoying, but lots of the converted entries are
> doing the same crap, instead of using a const var outside
> the code.
>
>> Which
>> annoys me is that try_module_get/module_put functionality.
>
> That is scary, as any failure there would prevent removing/unbinding
> a module. The core or some helper function should be handle it,
> to avoid the risk of get twice, put twice, never call put, etc.
>
>> You should be ideally able to unbind (and bind) modules like that:
>> echo 6-0008 > /sys/bus/i2c/drivers/a8293/unbind
>
> I guess unbinding a V4L2 module in real time won't cause any
> crash (obviously, the device will stop work properly, if you
> remove a component that it is being used).
>
> I actually tested remove/reinsert the I2C remote controller
> drivers a long time ago, while looking at some bugs. Those are
> usually harder to get it right, as most of them have a poll logic
> internally to get IR events on every 10ms. I guess I tested
> removing/reinserting the tuner too, but that was at the
> "stone ages"... to old for me to remember what I did.
>
> Yet, I don't see any troubles preventing the I2C "slave" drivers to
> be unbound before the master, by increasing their module refcounts
> during their usage.
>
>> and as it is not possible, that stuff is here to avoid problems. Some
>> study is needed in order to find out how dynamic unbind/bind could be
>> get working and after that I hope whole ref counting could be removed.
>> Currently you cannot allow remove module as it leads to unbind, which
>> does not work.

I did tons of work in order to get things work properly with I2C 
binding. And following things are now possible due to that:
* Kernel logging. You could now use standard dev_ logging.
* regmap. Could now use regmap in order to cover register access.
* I2C-mux. No need for i2c_gate_control.

And everytime there is someone asking why just don't do things like 
earlier :S

I really don't want add any new hacks but implement things as much as 
possible the way driver core makes possible. For long ran I feel it is 
better approach to follow driver core than make own hacks. Until someone 
study things and says it is not possible to implement things like core 
offers, then lets implement things. That's bind/unbind is one thing to 
study, another thing is power-management.

I suspect bind/unbind could be simple like just:
i2c_driver_remove()
{
     if (frontend_is_running)
         return -EBUSY;

     kfree(dev)
     return 0;
}

regards
Antti

-- 
http://palosaari.fi/
