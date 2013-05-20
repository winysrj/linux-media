Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:53427 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab3ETLwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 07:52:41 -0400
Message-ID: <519A0E85.40905@dct.mine.nu>
Date: Mon, 20 May 2013 13:52:37 +0200
From: Karsten Malcher <debian@dct.mine.nu>
Reply-To: debian@dct.mine.nu
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: gennarone@gmail.com, linux-media@vger.kernel.org
Subject: Re: Kernel freezing with RTL2832U+R820T
References: <51898A55.8050005@dct.mine.nu> <5189B5E1.3050201@gmail.com> <51965C42.4060801@dct.mine.nu> <5196902E.5030801@gmail.com> <51972F64.3080009@dct.mine.nu> <519A0108.1090101@gmail.com>
In-Reply-To: <519A0108.1090101@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.05.2013 12:55, schrieb poma:
> On 18.05.2013 09:36, Karsten Malcher wrote:
>> Hi Gianluca,
>>
>> the crash / freezing occurs before disconnect in normal operation.
>> So the patch will not solve this problem.
> Although media_build/backports allows you to build certain modules for
> certain older *kernels*, it doesn't mean that these modules will work
> tuneful within them. Therefore, I recommend the *recent* ones.
> Take note of last Mauro's git pull[1]. ;)
>
>
> poma
>
>
> [1] http://www.spinics.net/lists/linux-media/msg63181.html
>
>
Does this mean that it should work with Kernel 3.8.5 ?

Karsten
