Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:33415 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbbBFJUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Feb 2015 04:20:11 -0500
Received: by mail-we0-f172.google.com with SMTP id x3so6896392wes.3
        for <linux-media@vger.kernel.org>; Fri, 06 Feb 2015 01:20:10 -0800 (PST)
Message-ID: <54D48746.20201@movia.biz>
Date: Fri, 06 Feb 2015 10:20:06 +0100
From: Francesco Marletta <francesco.marletta@movia.biz>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Francesco Marletta <fmarletta@movia.biz>,
	=?ISO-8859-15?Q?Carlos_Sa?= =?ISO-8859-15?Q?nmart=EDn_Bustos?=
	<carsanbu@gmail.com>, Linux Media <linux-media@vger.kernel.org>
Subject: Re: Help required for TVP5151 on Overo
References: <20141119094656.5459258b@crow> <5213550.zrY0P2Gc9u@avalon> <54D37E67.6030103@movia.biz> <8229059.JSIBoG9XF0@avalon>
In-Reply-To: <8229059.JSIBoG9XF0@avalon>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
thanks for your reply... I'll disable device tree usage.

Also, I'll try to use a previous kernel (3.17) hoping it works.

Regards
Francesco

Il 05/02/2015 15:57, Laurent Pinchart ha scritto:
> Hi Francesco,
>
> On Thursday 05 February 2015 15:29:59 Francesco Marletta wrote:
>> Hi Laurent,
>> I'm trying to use the kernel of the linuxtv repository, omap3isp/tvp5151
>> branch,but the kernel don't starts... can you, please, send me the
>> kernel command line that you have used?
> I'm afraid I haven't kept the .config file around. I might also have rebased
> the working branch without testing the result, so it might just not work on
> 3.18-rc4. I'm sorry not to be able to help you for now.
>
>> Also, have you used device tree ?
> No, I was using legacy boot. The OMAP3 ISP driver doesn't support DT yet.
>

