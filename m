Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36160 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbcCKOjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Mar 2016 09:39:09 -0500
Received: by mail-io0-f169.google.com with SMTP id z76so147735645iof.3
        for <linux-media@vger.kernel.org>; Fri, 11 Mar 2016 06:39:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56E2C36C.6030709@samsung.com>
References: <1457122813-12791-1-git-send-email-javier@osg.samsung.com>
	<CAJKOXPfOpqU2fGsNNaB6n_iuq2r-8z3TCSsqkncPbvkK2344Tg@mail.gmail.com>
	<56DD48C1.8010004@samsung.com>
	<56DD9086.7070903@osg.samsung.com>
	<56E2C36C.6030709@samsung.com>
Date: Fri, 11 Mar 2016 11:39:08 -0300
Message-ID: <CABxcv==Y=G8R3kgHj_eidyzYRBq16LNc0ACGSPBHwB5SgMJARg@mail.gmail.com>
Subject: Re: [PATCH 0/2] [media] exynos4-is: Trivial fixes for DT
 port/endpoint parse logic
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kukjin Kim <kgene@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester,

On Fri, Mar 11, 2016 at 10:09 AM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 03/07/2016 03:30 PM, Javier Martinez Canillas wrote:
>> Thanks, I just noticed another similar issue in the driver now and is
>> that fimc_is_parse_sensor_config() uses the same struct device_node *
>> for looking up the I2C sensor, port and endpoint and thus not doing a
>> of_node_put() for all the nodes on the error path.
>>
>> I think the right fix is to have a separate struct device_node * for
>> each so their reference counter can be incremented and decremented.
>
> Yes, the node reference count is indeed not handled very well there,
> feel free to submit a patch to fix that bug.
>

Ok, I'll post a patch to fix that once all the in-flight patches land
to avoid merge conflicts.

> --
> Regards,
> Sylwester

Best regards,
Javier
