Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0GCXDD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jul 2010 19:03:03 -0400
Message-ID: <4C2FC0B6.9040407@redhat.com>
Date: Sat, 03 Jul 2010 19:59:02 -0300
From: Douglas Schilling Landgraf <dougsland@redhat.com>
Reply-To: dougsland@redhat.com
MIME-Version: 1.0
To: Mike Isely <isely@isely.net>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Julia Lawall <julia@diku.dk>
Subject: Re: [git:v4l-dvb/other] V4L/DVB: drivers/media/video/pvrusb2: Add
 missing mutex_unlock
References: <E1OV9yX-0006Dg-H2@www.linuxtv.org> <alpine.DEB.1.10.1007031733360.19299@cnc.isely.net>
In-Reply-To: <alpine.DEB.1.10.1007031733360.19299@cnc.isely.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mike,

Mike Isely wrote:
> Mauro:
> 
> FYI, I posted an "Acked-By: Mike Isely <isely@pobox.com>" weeks ago, 
> back on 27-May, immediately after the patch was posted.  It's a great 
> catch, and the bug has been there since basically the beginning of the 
> driver.  Was I ever supposed to see any kind of reaction to that ack 
> (e.g. having the "Acked-By" added to the patch)?  I had posted it in 
> reply to the original patch, copied back to the patch author, to lkml, 
> to linux-media, kernel-janitors, and Mauro.
> 
>   -Mike

It seems my mistake since I have added CC instead of Acked-by, sorry.
This happened because usually I add CC to the authors of drivers when I 
took patches from patchwork and I wanna notify them. In your case, I 
missed the acked-by.

Mauro, if possible, could you please replace CC to the correct Acked-by 
before submit this patch to Linus?

Thanks
Douglas
