Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2877 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZA2J3a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 04:29:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Compiler warnings in pxa_camera.c
Date: Thu, 29 Jan 2009 10:29:27 +0100
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901291029.27243.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

For some time now I see the following warnings in pxa_camera.c under
kernels 2.6.27 and 2.6.28 in the daily build:

  CC [M]  /marune/build/v4l-dvb-master/v4l/soc_camera.o
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:54:1: warning: "CICR0" redefined
In file included from /marune/build/v4l-dvb-master/v4l/pxa_camera.c:43:
arch/arm/mach-pxa/include/mach/pxa-regs.h:615:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:55:1: warning: "CICR1" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:616:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:56:1: warning: "CICR2" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:617:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:57:1: warning: "CICR3" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:618:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:58:1: warning: "CICR4" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:619:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:59:1: warning: "CISR" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:620:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:60:1: warning: "CIFR" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:621:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:61:1: warning: "CITOR" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:622:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:62:1: warning: "CIBR0" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:623:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:63:1: warning: "CIBR1" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:624:1: warning: this is the location of the previous definition
/marune/build/v4l-dvb-master/v4l/pxa_camera.c:64:1: warning: "CIBR2" redefined
arch/arm/mach-pxa/include/mach/pxa-regs.h:625:1: warning: this is the location of the previous definition

It compiles fine under 2.6.29.

Can you either try to fix this for kernels 2.6.27/28, or can I assume that
this driver will only compile correctly under 2.6.29?

I don't know what the status is of this driver for these older kernels, so I
don't dare touch this without input from you.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
