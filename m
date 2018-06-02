Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:33806 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbeFBWLx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Jun 2018 18:11:53 -0400
Subject: Re: [SIL2review] [PATCH] media: tc358743: release device_node in
 tc358743_probe_of()
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        ldv-project@linuxtesting.org, sil2review@lists.osadl.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
        linux-media@vger.kernel.org
References: <1527285240-12762-1-git-send-email-khoroshilov@ispras.ru>
 <20180526143834.GA28325@osadl.at>
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Message-ID: <a89812ad-8cbb-129f-4bb2-0c1d92d28598@ispras.ru>
Date: Sun, 3 Jun 2018 01:11:49 +0300
MIME-Version: 1.0
In-Reply-To: <20180526143834.GA28325@osadl.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.05.2018 17:38, Nicholas Mc Guire wrote:
> On Sat, May 26, 2018 at 12:54:00AM +0300, Alexey Khoroshilov wrote:
>> of_graph_get_next_endpoint() returns device_node with refcnt increased,
>> but these is no of_node_put() for it.
> 
> I think this is correct - but would it not be simpler to do
> 
>    endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
>    of_node_put(ep);
>    if (IS_ERR(endpoint)) {
>    ....
> 
> As the of_node_put(np) actually is unconditional anyway I think this
> should be semantically equivalent.

You are right. But the same is true for
v4l2_fwnode_endpoint_free(endpoint);
that is already correctly handled by the driver.
So, I have preferred to follow the same pattern.


> 
>>
>> The patch adds one on error and normal paths.
>>
>> Found by Linux Driver Verification project (linuxtesting.org).
>>
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Reviewed-by: Nicholas Mc Guire <der.herr@hofr.at>


Thank you,
Alexey
