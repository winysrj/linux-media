Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45063 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3F0LXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jun 2013 07:23:01 -0400
Received: by mail-lb0-f169.google.com with SMTP id d10so346456lbj.28
        for <linux-media@vger.kernel.org>; Thu, 27 Jun 2013 04:22:57 -0700 (PDT)
Message-ID: <51CC2091.1040408@cogentembedded.com>
Date: Thu, 27 Jun 2013 15:22:57 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	magnus.damm@gmail.com, linux@arm.linux.org.uk, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 0/3] R8A7779/Marzen R-Car VIN driver support
References: <201305160153.29827.sergei.shtylyov@cogentembedded.com> <20130627074129.GB13927@verge.net.au>
In-Reply-To: <20130627074129.GB13927@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 27-06-2013 11:41, Simon Horman wrote:

>>     Here's the set of 3 patches against the Simon Horman's 'renesas.git' repo,
>> 'renesas-next-20130515v2' tag and my recent yet unapplied USB/I2C patches.
>> Here we add the VIN driver platform code for the R8A7779/Marzen with ADV7180
>> I2C video decoder.

>> [1/3] ARM: shmobile: r8a7779: add VIN support
>> [2/3] ARM: shmobile: Marzen: add VIN and ADV7180 support
>> [3/3] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig

>>     The VIN driver itself has been excluded from the series as it will be developed
>> against Mauro's 'media_tree.git' plus some yet unapplied patches in the future...

> Sergei, is this patch-set still needing review?

    Probably. Note that it depends on the VIN driver too.

WBR, Sergei


