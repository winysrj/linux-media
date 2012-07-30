Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57776 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2G3Vfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 17:35:41 -0400
Message-ID: <5016FE29.9020406@gmail.com>
Date: Mon, 30 Jul 2012 23:35:37 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com,
	Karol Lewandowski <k.lewandowsk@samsung.com>
Subject: Re: [RFC/PATCH 05/13] media: s5p-fimc: Add device tree support for
 FIMC devices
References: <4FBFE1EC.9060209@samsung.com> <Pine.LNX.4.64.1207180958540.8472@axis700.grange> <5007143E.8040807@gmail.com> <3360710.ek62A7CVxd@avalon>
In-Reply-To: <3360710.ek62A7CVxd@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 07/26/2012 04:54 PM, Laurent Pinchart wrote:
> On Wednesday 18 July 2012 21:53:34 Sylwester Nawrocki wrote:
>> I think we need a one combined RFC and continue discussions in one thread.
> 
> Agreed.
> 
>> Still, our proposals are quite different, but I believe we need something
>> in between. I presume we should focus more to have common bindings for
>> subdevs that are reused among different host/ISP devices, i.e. sensors and
>> encoders. For simple host interfaces we can likely come up with common
>> binding patterns, but more complex processing pipelines may require
>> a sort of individual approach.
>>
>> The suspend/resume handling is still something I don't have an idea
>> on how the solution for might look like..
>> Instantiating all devices from a top level driver could help, but it
>> is only going to work when platforms are converted to the common clock
>> framework and have their clocks instantiated from device tree.
>>
>> This week I'm out of office, and next one or two I have some pending
>> assignments. So there might be some delay before I can dedicate some
>> reasonable amount of time to carry on with that topic.
>>
>> I unfortunately won't be attending KS this time.
> 
> That's bad news :-( I still think this topic should be discussed during KS, I

Yeah, shit happens.. :) I guess -ENOBUDGET this time... I didn't really 
plan early to attend KS, I might be coming to ELCE though. However it's 
a rather distant event and we'll probably get most things settled by 
that time.

> expect several developers to be interested. The media workshop might not be
> the best venue though, as we might need quite a lot of time.
>
> Until KS let's continue the discussion by e-mail.

OK, thank you for taking time to review the RFCs.

--

Regards,
Sylwester
