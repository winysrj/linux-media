Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:45785 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1ARWQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 17:16:43 -0500
Message-ID: <4D361139.7080101@infradead.org>
Date: Tue, 18 Jan 2011 20:16:25 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9 v2] Altera FPGA based CI driver module.
References: <4d20723d.cc7e0e0a.6f59.3762@mx.google.com> <4D333066.3020203@infradead.org> <201101182123.31987.liplianin@me.by>
In-Reply-To: <201101182123.31987.liplianin@me.by>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-01-2011 17:23, Igor M. Liplianin escreveu:
> В сообщении от 16 января 2011 19:52:38 автор Mauro Carvalho Chehab написал:
>> Em 02-01-2011 10:01, Igor M. Liplianin escreveu:
>>> An Altera FPGA CI module for NetUP Dual DVB-T/C RF CI card.
>>>
>>> Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
>>
>> Igor,
>>
>> There's something wrong with this patch. I got lots of error after applying
>> it:
>>
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_ci_read_attribute_mem':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:304:
>> multiple definition of `netup_ci_read_attribute_mem'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:241: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function `netup_ci_op_cam':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:269:
>> multiple definition of `netup_ci_op_cam'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:171: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_ci_slot_shutdown':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:364:
>> multiple definition of `netup_ci_slot_shutdown'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:293: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_ci_slot_ts_ctl':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:370:
>> multiple definition of `netup_ci_slot_ts_ctl'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:320: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_ci_write_cam_ctl':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:322:
>> multiple definition of `netup_ci_write_cam_ctl'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:259: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_ci_read_cam_ctl':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:315:
>> multiple definition of `netup_ci_read_cam_ctl'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:252: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_ci_write_attribute_mem':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:310:
>> multiple definition of `netup_ci_write_attribute_mem'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:247: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_poll_ci_slot_status':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:448:
>> multiple definition of `netup_poll_ci_slot_status'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:403: first defined here
>> drivers/media/video/cx23885/altera-ci.o: In function
>> `netup_ci_slot_reset':
>> /home/v4l/v4l/patchwork/drivers/media/video/cx23885/altera-ci.c:327:
>> multiple definition of `netup_ci_slot_reset'
>> drivers/media/video/cx23885/cx23885.o:/home/v4l/v4l/patchwork/drivers/medi
>> a/video/cx23885/cimax2.c:264: first defined here
>>
>>
>> Please fix it and submit a new version. The better is to replace all those
>> new symbols to start with altera_ci.
> I see, allyesconfig...

Yes.

>>
>> While here, please, on the first patch, move the Altera FPGA driver to
>> staging, to give people some time do discuss about it.
> It means that cx23885 driver will depend on staging. Is it OK?

The idea is to enable the Altera-dependent part of cx23885 only if compiled.
There's no need to make the entire cx2388x dependent of Altera driver.
> 
>>
>> PS.: there are a few CodingStyle errors on this patch. Please always review
>> your patches with ./scripts/checkpatch.pl.
> I'll do it.

Ok, thanks!
>>
>> Thanks!
>> Mauro
> 

