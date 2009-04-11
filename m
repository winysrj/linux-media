Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1479 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZDKKsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2009 06:48:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Brandon Jenkins <bcjenkins@tvwhere.com>
Subject: Re: ir-kbd-i2c Compile Warnings
Date: Sat, 11 Apr 2009 12:48:31 +0200
Cc: linux-media@vger.kernel.org
References: <de8cad4d0904100710u1cdd9568ud3190b1e97e792e3@mail.gmail.com> <de8cad4d0904101659r7564ae3cne075ea355aff73ac@mail.gmail.com>
In-Reply-To: <de8cad4d0904101659r7564ae3cne075ea355aff73ac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904111248.31390.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 11 April 2009 01:59:00 Brandon Jenkins wrote:
> On Fri, Apr 10, 2009 at 10:10 AM, Brandon Jenkins <bcjenkins@tvwhere.com> 
wrote:
> > Hello all,
> >
> > Fresh clone of V4L this morning running on a fully patched ArchLinux
> > 64-bit system:
> >
> > /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.o
> > /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c: In function 'ir_attach':
> > /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:429: warning:
> > 'i2c_attach_client' is deprecated (declared at
> > include/linux/i2c.h:434)
> > /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:468: warning:
> > 'i2c_detach_client' is deprecated (declared at
> > include/linux/i2c.h:435)
> > /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c: In function 'ir_detach':
> > /root/drivers/v4l-dvb/v4l/ir-kbd-i2c.c:484: warning:
> > 'i2c_detach_client' is deprecated (declared at
> > include/linux/i2c.h:435)
> >
> > Brandon
> >
> > uname -a
> > Linux sagetv-server 2.6.29-ARCH #1 SMP PREEMPT Wed Apr 8 12:39:28 CEST
> > 2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel
> > GNU/Linux
>
> Rolling back to kernel:
>
> Linux sagetv-server 2.6.28-ARCH #1 SMP PREEMPT Tue Mar 17 07:22:53 CET
> 2009 x86_64 Intel(R) Core(TM)2 Quad CPU Q6600 @ 2.40GHz GenuineIntel
> GNU/Linux
>
> Does not produce the same warnings.

Known harmless issue for 2.6.29. Jean Delvare and others are working on 
removing these deprecated calls for 2.6.30.

Regards,

	Hans

>
> Thanks,
>
> Brandon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
