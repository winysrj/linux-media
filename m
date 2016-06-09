Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39848 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbcFIPlO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 11:41:14 -0400
Subject: Re: dvb-core: how should i2c subdev drivers be attached?
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Akihiro TSUKADA <tskd08@gmail.com>
References: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
 <20160609122449.5cfc16cc@recife.lan>
Cc: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <07669546-908f-f81c-26e5-af7b720229b3@iki.fi>
Date: Thu, 9 Jun 2016 18:41:10 +0300
MIME-Version: 1.0
In-Reply-To: <20160609122449.5cfc16cc@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2016 06:24 PM, Mauro Carvalho Chehab wrote:
> Hi Akihiro,
>
> Em Thu, 09 Jun 2016 21:49:33 +0900
> Akihiro TSUKADA <tskd08@gmail.com> escreveu:
>
>> Hi,
>> excuse me for taking up a very old post again,
>> but I'd like to know the status of the patch:
>>   https://patchwork.linuxtv.org/patch/27922/
>> , which provides helper code for defining/loading i2c DVB subdev drivers.
>>
>> Was it rejected and
>
> It was not rejected. It is just that I didn't have time yet to think
> about that, and Antti has a different view.
>
> The thing is that, whatever we do, it should work fine on drivers that
> also exposes the tuner via V4L2. One of the reasons is that devices
> that also allow the usage for SDR use the V4L2 core for the SDR part.
>
>> each i2c demod/tuner drivers should provide its own version of "attach" code?
>
> Antti took this path, but I don't like it. Lots of duplicated and complex
> stuff. Also, some static analyzers refuse to check it (like smatch),
> due to its complexity.
>
>> Or is it acceptable (with some modifications) ?
>
> I guess we should discuss a way of doing it that will be acceptable
> on existing drivers. Perhaps you should try to do such change for
> an hybrid driver like em28xx or cx231xx. There are a few ISDB-T
> devices using them. Not sure how easy would be to find one of those
> in Japan, though.
>
>>
>> Although not many drivers currently use i2c binding model (and use dvb_attach()),
>> but I expect that coming DVB subdev drivers will have a similar attach code,
>> including module request/ref-counting, device creation,
>> (re-)using i2c_board_info.platformdata to pass around both config parameters
>> and the resulting i2c_client* & dvb_frontend*.
>>
>> Since I have a plan to split out demod/tuner drivers from pci/pt1 dvb-usb/friio
>> integrated drivers (because those share the tc90522 demod driver with pt3, and
>> friio also shares the bridge chip with gl861),
>> it would be nice if I can use the helper code,
>> instead of re-iterating similar "attach" code.

IMHO only thing which makes it looking complex is that module reference 
counting - otherwise it is just standard I2C binding. Ideally I2C 
modules should be possible to unbind and unload at runtime and also load 
and bind. There is "suppress_bind_attrs = true" set to prevent runtime 
unbinding and try_module_get() is to prevent module unloading. For me 
eyes all that is still some workaround - and now you want put this 
workaround to some generic code. Please find correct solutions for those 
two problems and then there we can get rid of things totally - no need 
to make generic functions at all.

regards
Antti

-- 
http://palosaari.fi/
