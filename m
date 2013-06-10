Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58180 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab3FJRsa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 13:48:30 -0400
Message-ID: <51B61143.3080307@iki.fi>
Date: Mon, 10 Jun 2013 20:47:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: marco caminati <marco.caminati@yahoo.it>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: rtl28xxu IR remote
References: <51B26AF1.2000005@gmail.com> <1370876006.1569.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1370876948.45967.YahooMailNeo@web28904.mail.ir2.yahoo.com>
In-Reply-To: <1370876948.45967.YahooMailNeo@web28904.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/10/2013 06:09 PM, marco caminati wrote:
>
>
>> Hi, I just compiled and tested Antti Palosaari branch and can confirm the remote works for my RTL2832U.
>> I have updated the wiki[1] entry with the steps necessary to configure the remote control.
>> Please confirm if these fixes your problem.
>
>
> Thanks, but I can't confirm if this fixes my problem, because the modules I obtain building Antti's branch are not compatible with my existing kernel, so I can't test them (modprobe --force fails, and using a brand new kernel would be too much work on Tinycore at the moment).
> On the other hand, I tried the sources fromgit://linuxtv.org/media_build.git, first with manual patches and then (when the latter got accepted) without them. But the ir remote does not work.
>
> I think Antti's repo and patching linuxtv repo should lead to the same results, right?

I think the most easiest way could be compile & install whole Kernel 
from my tree. It is 3.10-rc4 + some fixes.

media_build.git has also option to fetch developer git tree from 
linuxtv.org. Something like ./build --git 
git://linuxtv.org/anttip/media_tree.git rtl28xxu . That approach seem to 
be not documented on wiki:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers


regards
Antti

-- 
http://palosaari.fi/
