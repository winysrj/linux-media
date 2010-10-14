Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34239 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0JNS6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 14:58:12 -0400
Received: by ewy20 with SMTP id 20so3823029ewy.19
        for <linux-media@vger.kernel.org>; Thu, 14 Oct 2010 11:58:11 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37]  Support for NetUP Dual DVB-T/C CI RF card
Date: Thu, 14 Oct 2010 21:58:07 +0300
Cc: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>
References: <201010040135.59454.liplianin@me.by> <4CB74279.1070103@redhat.com> <4CB743EC.90708@redhat.com>
In-Reply-To: <4CB743EC.90708@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010142158.07974.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 14 октября 2010 20:54:52 автор Mauro Carvalho Chehab написал:
> Em 14-10-2010 14:48, Mauro Carvalho Chehab escreveu:
> > Em 03-10-2010 19:35, Igor M. Liplianin escreveu:
> >> Patches to support for NetUP Dual DVB-T/C-CI RF from NetUP Inc.
> >> 
> >> 	http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF
> >> 
> >> Features:
> >> 
> >> PCI-e x1
> >> Supports two DVB-T/DVB-C transponders simultaneously
> >> Supports two analog audio/video channels simultaneously
> >> Independent descrambling of two transponders
> >> Hardware PID filtering
> >> 
> >> Components:
> >> 
> >> Conexant CX23885
> >> STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip
> >> receiver Xceive XC5000 silicon TV tuner
> >> Altera FPGA for Common Interafce
> >> 
> >> The following changes since commit c8dd732fd119ce6d562d5fa82a10bbe75a376575:
> >>   V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of
> >>   sn9c102 (2010-10-01
> >> 
> >> 18:14:35 -0300)
> >> 
> >> are available in the git repository at:
> >>   http://udev.netup.ru/git/v4l-dvb.git netup-for-media-tree
> > 
> > Hmm... it is not working... perhaps you forgot to run git
> > update-server-info.
> 
> It worked. It just took a very long time to update...
> 
> >>  drivers/misc/Kconfig                        |    1 +
> >>  drivers/misc/Makefile                       |    1 +
> >>  drivers/misc/stapl-altera/Kconfig           |    8 +
> >>  drivers/misc/stapl-altera/Makefile          |    3 +
> >>  drivers/misc/stapl-altera/altera.c          | 2739 ++++++++++++++++++++
> >>  drivers/misc/stapl-altera/jbicomp.c         |  163 ++
> >>  drivers/misc/stapl-altera/jbiexprt.h        |   94 +
> >>  drivers/misc/stapl-altera/jbijtag.c         | 1038 ++++++++
> >>  drivers/misc/stapl-altera/jbijtag.h         |   83 +
> >>  drivers/misc/stapl-altera/jbistub.c         |   70 +
> >>  include/misc/altera.h                       |   49 +
> > 
> > Hmm... that's new for me... a driver at misc?
> 
> Hmm... a FPGA programming driver... Is it needed to for the DVB device to
> work, or it is used only when programming the device at the manufacturer?
Yes, it needed for DVB device to work. FPGA model used in device has not flash memory. 
Then FPGA itself drives CI and hardware PID filter.
We all realize, that FPGA programming not belongs to DVB only, it is more common.
So maybe misc is the place. 

> 
> Cheers,
> Mauro.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
