Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:36231 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244AbbIYVkP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2015 17:40:15 -0400
Received: by laclj5 with SMTP id lj5so16714531lac.3
        for <linux-media@vger.kernel.org>; Fri, 25 Sep 2015 14:40:14 -0700 (PDT)
Subject: Re: [git:media_tree/master] [media] rcar_vin: call g_std() instead of
 querystd()
References: <E1ZfZpS-0004ra-EU@www.linuxtv.org>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <5605BF3C.5040309@cogentembedded.com>
Date: Sat, 26 Sep 2015 00:40:12 +0300
MIME-Version: 1.0
In-Reply-To: <E1ZfZpS-0004ra-EU@www.linuxtv.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 09/25/2015 11:32 PM, Mauro Carvalho Chehab wrote:

> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
>
> Subject: [media] rcar_vin: call g_std() instead of querystd()
> Author:  Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Date:    Thu Sep 3 20:18:05 2015 -0300
>
> Hans Verkuil says: "The only place querystd can be called  is in the QUERYSTD
> ioctl, all other ioctls should use the last set standard." So call the g_std()
> subdevice method instead of querystd() in the driver's set_fmt() method.
>
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

    Note that merging this patch without the 2 patches preceding it in the the 
series will break the frame capture.

MBR, Sergei

