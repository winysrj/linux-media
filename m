Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:56333 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0CAHKP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 02:10:15 -0500
Message-ID: <4B8B6853.3050801@freemail.hu>
Date: Mon, 01 Mar 2010 08:10:11 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Adams Xu <Adams.xu@azwave.com.cn>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: az6027: variables may be used uninitialized in az6027_i2c_xfer()
References: <201002281949.o1SJnGO7064642@smtp-vbr12.xs4all.nl>
In-Reply-To: <201002281949.o1SJnGO7064642@smtp-vbr12.xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adams,

Hans Verkuil wrote:
> This message is generated daily by a cron job that builds v4l-dvb for
> the kernels and architectures in the list below.
> [...]
>
> Detailed results are available here:
> 
> http://www.xs4all.nl/~hverkuil/logs/Sunday.log


> linux-2.6.29.1-i686: WARNINGS
>
> /home/hans/work/build/v4l-dvb-master/v4l/az6027.c: In function 'az6027_i2c_xfer':
> /home/hans/work/build/v4l-dvb-master/v4l/az6027.c:942: warning: 'index' may be used uninitialized in this function
> /home/hans/work/build/v4l-dvb-master/v4l/az6027.c:943: warning: 'value' may be used uninitialized in this function
> /home/hans/work/build/v4l-dvb-master/v4l/az6027.c:944: warning: 'length' may be used uninitialized in this function
> /home/hans/work/build/v4l-dvb-master/v4l/az6027.c:945: warning: 'req' may be used uninitialized in this function

I checked what can cause these warning messages and found that in
line 990 of linux/drivers/media/dvb/dvb-usb/az6027.c the function
az6027_usb_out_op() is called. Before that call it seems that the
condition (msg[i].addr == 0xd0) is checked for the second time which
is redundant.

Regards,

	Márton Németh
