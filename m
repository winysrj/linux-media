Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:62209 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZDJX7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 19:59:01 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1534264qwh.37
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2009 16:59:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <de8cad4d0904100710u1cdd9568ud3190b1e97e792e3@mail.gmail.com>
References: <de8cad4d0904100710u1cdd9568ud3190b1e97e792e3@mail.gmail.com>
Date: Fri, 10 Apr 2009 19:59:00 -0400
Message-ID: <de8cad4d0904101659r7564ae3cne075ea355aff73ac@mail.gmail.com>
Subject: Re: ir-kbd-i2c Compile Warnings
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 10, 2009 at 10:10 AM, Brandon Jenkins <bcjenkins@tvwhere.com> wrote:
> Hello all,
>
> Fresh clone of V4L this morning running on a fully patched ArchLinux
> 64-bit system:
>
> /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.o
> /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c: In function 'ir_attach':
> /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:429: warning:
> 'i2c_attach_client' is deprecated (declared at
> include/linux/i2c.h:434)
> /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:468: warning:
> 'i2c_detach_client' is deprecated (declared at
> include/linux/i2c.h:435)
> /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c: In function 'ir_detach':
> /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:484: warning:
> 'i2c_detach_client' is deprecated (declared at
> include/linux/i2c.h:435)
>
> Brandon
>
> uname -a
> Linux sagetv-server 2.6.29-ARCH #1 SMP PREEMPT Wed Apr 8 12:39:28 CEST
> 2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel
> GNU/Linux
>

Rolling back to kernel:

Linux sagetv-server 2.6.28-ARCH #1 SMP PREEMPT Tue Mar 17 07:22:53 CET
2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel
GNU/Linux

Does not produce the same warnings.

Thanks,

Brandon
