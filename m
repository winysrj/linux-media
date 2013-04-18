Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:42309 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965997Ab3DROWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 10:22:21 -0400
Received: by mail-la0-f42.google.com with SMTP id fn20so2609633lab.29
        for <linux-media@vger.kernel.org>; Thu, 18 Apr 2013 07:22:20 -0700 (PDT)
Message-ID: <51700158.101@cogentembedded.com>
Date: Thu, 18 Apr 2013 18:21:12 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, magnus.damm@gmail.com,
	linux-media@vger.kernel.org, matsu@igel.co.jp
Subject: Re: [PATCH 4/4] ARM: shmobile: Marzen: enable VIN and ADV7180 in
 defconfig
References: <201304180206.39465.sergei.shtylyov@cogentembedded.com> <201304180217.28176.sergei.shtylyov@cogentembedded.com> <20130418133022.GD20929@verge.net.au>
In-Reply-To: <20130418133022.GD20929@verge.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18-04-2013 17:30, Simon Horman wrote:

>> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

>> Add the VIN and ADV7180 drivers to 'marzen_defconfig'.

>> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>> ---
>>   arch/arm/configs/marzen_defconfig |    7 +++++++
>>   1 file changed, 7 insertions(+)

> Thanks, queued-up for v3.11 in the defconfig-marzen branch.

    That seems somewhat premature as CONFIG_VIDEO_RCAR_VIN is not defined yet 
(it's defined in the patch #1 of this series).

WBR, Sergei

