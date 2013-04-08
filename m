Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58130 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935990Ab3DHJxz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 05:53:55 -0400
Message-ID: <516293A2.8040908@ti.com>
Date: Mon, 8 Apr 2013 15:23:38 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH v3] media: davinci: kconfig: fix incorrect selects
References: <513EE45E.6050004@ti.com> <1363079692-16683-1-git-send-email-nsekhar@ti.com> <CA+V-a8ug3fre3WWp=1cri7rcPMFC+vhCOMkAViUyMz7yQ5nPaQ@mail.gmail.com>
In-Reply-To: <CA+V-a8ug3fre3WWp=1cri7rcPMFC+vhCOMkAViUyMz7yQ5nPaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4/8/2013 1:39 PM, Prabhakar Lad wrote:
> Hi Sekhar,

>>  config VIDEO_DAVINCI_VPBE_DISPLAY
>> -       tristate "DM644X/DM365/DM355 VPBE HW module"
>> -       depends on ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM355 || ARCH_DAVINCI_DM365
>> -       select VIDEO_VPSS_SYSTEM
>> +       tristate "TI DaVinci VPBE V4L2-Display driver"
>> +       depends on ARCH_DAVINCI
>>         select VIDEOBUF2_DMA_CONTIG
>>         help
>>             Enables Davinci VPBE module used for display devices.
>> -           This module is common for following DM644x/DM365/DM355
>> +           This module is used for dipslay on TI DM644x/DM365/DM355
>>             based display devices.
>>
> s/dipslay/display
> 
> Fixed it while queueing

Thanks!

Regards,
Sekhar
