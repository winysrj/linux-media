Return-path: <mchehab@gaivota>
Received: from smtp.work.de ([212.12.45.188]:45558 "EHLO smtp2.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab0LNRYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 12:24:03 -0500
Message-ID: <4D07A829.6080406@jusst.de>
Date: Tue, 14 Dec 2010 18:23:53 +0100
From: Julian Scheel <julian@jusst.de>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-2200 analog
References: <4CFE14A1.3040801@jusst.de> <1291726869.2073.5.camel@morgan.silverblock.net>
In-Reply-To: <1291726869.2073.5.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am 07.12.2010 14:01, schrieb Andy Walls:
> On Tue, 2010-12-07 at 12:04 +0100, Julian Scheel wrote:
>> Hi,
>>
>> is there any progress on adding analog support to the HVR-2200?
>> It seems support for the used chipsets in general is already in the kernel?
> It appears to be in the media_tree.git repository on the
> staging/for_v2.6.37-rc1 branch:
>
> http://git.linuxtv.org/media_tree.git?a=tree;f=drivers/media/video/saa7164;h=0acaa4ada45ae6881bfbb19447ae9db43f06ef9b;hb=staging/for_v2.6.37-rc1
>
> saa7164-cards.c appears to have analog entries added for HVR-2200's and
> saa7164-encoder.c has a number of V4L ioctl()'s for MPEG streams.
Is there any reason, why the additional card-information found here:
http://www.kernellabs.com/hg/~stoth/saa7164-dev/
is not yet in the kernel tree?

