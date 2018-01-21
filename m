Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56635 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbeAUSFE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Jan 2018 13:05:04 -0500
Subject: Re: [PATCH v6 0/9] Renesas Capture Engine Unit (CEU) V4L2 driver
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1516139101-7835-1-git-send-email-jacopo+renesas@jmondi.org>
 <b26ef29e-0c26-6359-1205-735e6770eb10@infradead.org>
 <20180121175445.GQ24926@w540>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <830114e9-c559-fc3a-05ac-938959c69999@infradead.org>
Date: Sun, 21 Jan 2018 10:04:58 -0800
MIME-Version: 1.0
In-Reply-To: <20180121175445.GQ24926@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/2018 09:54 AM, jacopo mondi wrote:
> Hi Randy,
>    thanks for noticing,
> 
> On Fri, Jan 19, 2018 at 02:12:19PM -0800, Randy Dunlap wrote:
>> On 01/16/2018 01:44 PM, Jacopo Mondi wrote:
>>> Hello,
>>>    new version of CEU after Hans' review.
>>>
>>> Added his Acked-by to most patches and closed review comments.
>>> Running v4l2-compliance, I noticed a new failure introduced by the way I now
>>> calculate the plane sizes in set/try_fmt.
>>
>> I would expect that you have already seen this, but I get a build error
>> in renesas-ceu.c.  Here is a small patch for it.
> 
> Actually I did not.
> The compile error has been introduced by this commit
> 
> commit 4e48afecd5ee3a394d228349fc1c33982e9fb557
> Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Date:   Wed Sep 27 10:12:00 2017 -0400
>         media: v4l2-async: simplify v4l2_async_subdev structure
> 
> Which is not in v4.15-rc8 on which I have based my work on.
> 
> As a general question, if I'm aiming to have my driver included in
> next release, should I always base my work on linux-next or it depends
> on sub-system/maintainers preferences?

That's up to the subsystem maintainer, but usually you should make sure
that it will apply to linux-next or to the subsystem's "-next" tree,
whatever that is called.

>>
>> ---
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix build error (on x86 with COMPILE_TEST):
>>
>> ../drivers/media/platform/renesas-ceu.c: In function 'ceu_parse_dt':
>> ../drivers/media/platform/renesas-ceu.c:1497:27: error: request for member 'fwnode' in something not a structure or union
>>    ceu_sd->asd.match.fwnode.fwnode =
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> ---
>>  drivers/media/platform/renesas-ceu.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- linux-next-20180119.orig/drivers/media/platform/renesas-ceu.c
>> +++ linux-next-20180119/drivers/media/platform/renesas-ceu.c
>> @@ -1494,7 +1494,7 @@ static int ceu_parse_dt(struct ceu_devic
>>
>>  		ceu_sd->mbus_flags = fw_ep.bus.parallel.flags;
>>  		ceu_sd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
>> -		ceu_sd->asd.match.fwnode.fwnode =
>> +		ceu_sd->asd.match.fwnode =
>>  			fwnode_graph_get_remote_port_parent(
>>  					of_fwnode_handle(ep));
>>
>>


-- 
~Randy
