Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731AbZLITIY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 14:08:24 -0500
Message-ID: <4B1FF5AB.30405@redhat.com>
Date: Wed, 09 Dec 2009 17:08:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Huang Shijie <shijie8@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 00/11] add linux driver for chip TLG2300
References: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
In-Reply-To: <1258687493-4012-1-git-send-email-shijie8@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Huang Shijie wrote:
> The TLG2300 is a chip of Telegent System.
> It support analog tv,DVB-T and radio in a single chip.
> The chip has been used in several dongles, such as aeromax DH-9000:
> 	http://www.b2bdvb.com/dh-9000.htm
> 
> You can get more info from:
> 	[1] http://www.telegent.com/
> 	[2] http://www.telegent.com/press/2009Sept14_CSI.html
> 
> Huang Shijie (10):
>   add maitainers for tlg2300
>   add readme file for tlg2300
>   add Kconfig and Makefile for tlg2300
>   add header files for tlg2300
>   add the generic file
>   add video file for tlg2300
>   add vbi code for tlg2300
>   add audio support for tlg2300
>   add DVB-T support for tlg2300
>   add FM support for tlg2300
> 

Ok, finished reviewing it.

Patches 01, 02 and 04 seems ok to me. You didn't sent a patch 03.
Patch 05 will likely need some changes (the headers) due to some reviews I did
on the other patches.

The other patches need some adjustments, as commented on separate emails.

Cheers,
Mauro.
