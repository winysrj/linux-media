Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:5630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032Ab0JNTFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:05:06 -0400
Message-ID: <4CB7545B.7010609@redhat.com>
Date: Thu, 14 Oct 2010 16:04:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>
Subject: Re: [GIT PATCHES FOR 2.6.37]  Support for NetUP Dual DVB-T/C CI RF
 card
References: <201010040135.59454.liplianin@me.by> <4CB74279.1070103@redhat.com> <4CB743EC.90708@redhat.com> <201010142158.07974.liplianin@me.by>
In-Reply-To: <201010142158.07974.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-10-2010 15:58, Igor M. Liplianin escreveu:
> В сообщении от 14 октября 2010 20:54:52 автор Mauro Carvalho Chehab написал:
>> Em 14-10-2010 14:48, Mauro Carvalho Chehab escreveu:
>>> Em 03-10-2010 19:35, Igor M. Liplianin escreveu:
>>>> Patches to support for NetUP Dual DVB-T/C-CI RF from NetUP Inc.
>>>>
>>>> 	http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF
>>>>
>>>> Features:
>>>>
>>>> PCI-e x1
>>>> Supports two DVB-T/DVB-C transponders simultaneously
>>>> Supports two analog audio/video channels simultaneously
>>>> Independent descrambling of two transponders
>>>> Hardware PID filtering
>>>>
>>>> Components:
>>>>
>>>> Conexant CX23885
>>>> STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip
>>>> receiver Xceive XC5000 silicon TV tuner
>>>> Altera FPGA for Common Interafce
>>>>
>>>> The following changes since commit c8dd732fd119ce6d562d5fa82a10bbe75a376575:
>>>>   V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of
>>>>   sn9c102 (2010-10-01
>>>>
>>>> 18:14:35 -0300)
>>>>
>>>> are available in the git repository at:
>>>>   http://udev.netup.ru/git/v4l-dvb.git netup-for-media-tree
>>>
>>> Hmm... it is not working... perhaps you forgot to run git
>>> update-server-info.
>>
>> It worked. It just took a very long time to update...
>>
>>>>  drivers/misc/Kconfig                        |    1 +
>>>>  drivers/misc/Makefile                       |    1 +
>>>>  drivers/misc/stapl-altera/Kconfig           |    8 +
>>>>  drivers/misc/stapl-altera/Makefile          |    3 +
>>>>  drivers/misc/stapl-altera/altera.c          | 2739 ++++++++++++++++++++
>>>>  drivers/misc/stapl-altera/jbicomp.c         |  163 ++
>>>>  drivers/misc/stapl-altera/jbiexprt.h        |   94 +
>>>>  drivers/misc/stapl-altera/jbijtag.c         | 1038 ++++++++
>>>>  drivers/misc/stapl-altera/jbijtag.h         |   83 +
>>>>  drivers/misc/stapl-altera/jbistub.c         |   70 +
>>>>  include/misc/altera.h                       |   49 +
>>>
>>> Hmm... that's new for me... a driver at misc?
>>
>> Hmm... a FPGA programming driver... Is it needed to for the DVB device to
>> work, or it is used only when programming the device at the manufacturer?
> Yes, it needed for DVB device to work. FPGA model used in device has not flash memory. 
> Then FPGA itself drives CI and hardware PID filter.

Hmm... interesting design.

> We all realize, that FPGA programming not belongs to DVB only, it is more common.

Agreed.

> So maybe misc is the place. 

Maybe misc is the better place, not really sure. Well, I posted your altera patch to LKML, and
just sent my review.

Better to continue those discussions on the thread where LKML is c/c, to allow more readers
to be able to follow the entire discussions.

Cheers,
Mauro.
