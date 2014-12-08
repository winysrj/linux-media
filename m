Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:59932 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaLHLMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 06:12:48 -0500
Message-ID: <548587AA.80200@southpole.se>
Date: Mon, 08 Dec 2014 12:12:42 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] mn88472: fix firmware loading
References: <1417990203-758-1-git-send-email-benjamin@southpole.se> <1417990203-758-2-git-send-email-benjamin@southpole.se> <5484D666.6060605@iki.fi>
In-Reply-To: <5484D666.6060605@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/2014 11:36 PM, Antti Palosaari wrote:
> On 12/08/2014 12:10 AM, Benjamin Larsson wrote:
>> The firmware must be loaded one byte at a time via the 0xf6 register.
>
> I don't think so. Currently it downloads firmware in 22 byte chunks 
> and it seems to work, at least for me, both mn88472 and mn88473.

With both these changes I get much better sensitivity. So something is 
better then before. I will track down the needed changes and respin the 
patches.

MvH
Benjamin Larsson
