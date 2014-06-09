Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45133 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbaFIJSs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jun 2014 05:18:48 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6W00JK59V6QT70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 09 Jun 2014 10:18:42 +0100 (BST)
Message-id: <53957BED.5070707@samsung.com>
Date: Mon, 09 Jun 2014 11:18:37 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Nikhil Devshatwar <niksdevice@gmail.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: V4L2 endpoint parser doesn't support empty ports
References: <CAO-sSBvUGw56E15j9h_T+mBkF6Veu4GwFqTzPmA_qZAei3r90g@mail.gmail.com>
In-reply-to: <CAO-sSBvUGw56E15j9h_T+mBkF6Veu4GwFqTzPmA_qZAei3r90g@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikhil,

On 09/06/14 10:22, Nikhil Devshatwar wrote:
> Hi everyboady,
> 
> When using V4l2 endpoint framework for parsing device tree nodes,
> 
> I don't find any API which can allow me to iterate over all the
> endpoints in a specific port
> 
> Currectly we have v4l2_of_get_next_endpoint which can be used to
> iterate over all the endpoints
> under that device_node
> 
> Typically, SoCs have multiple video ports in a video IP
> We want a way to iterate over only the endpoints which belong to a certain port
> It isn't possible with this
> 
> Also, Ideally, all the port definitions are in DTSI file whereas the
> endpoints would be defined
> in a DTS file overriding the port nodes
> 
> So it is quite possible that we have some ports where nothing is connected,
> v4l2_of_get_next_endpoint fails as soon as it gets the empty endpoint
> 
> 2 questions
> => Should we modify the v4l2_of_get_next_endpoint function to ignore
> empty endpoints?

Laurent addressed this issue with patch: https://patchwork.linuxtv.org/patch/22927
I'm not sure what kernel version you are using. Such changes are already
in Linus' tree, however git history might not be straightforward due
to merge conflict resolutions. See commit 3c83e61 
"Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media"

> => Does it make sense to create a new function which can iterate over
> a specific port?

The 'port' node can have only 'endpoint' subnodes, so once you get hold
of the port node it should be as easy as iterating over its children ?

--
Regards,
Sylwester
