Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:32979 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab3CLIQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 04:16:43 -0400
Message-ID: <513EE45E.6050004@ti.com>
Date: Tue, 12 Mar 2013 13:46:30 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: davinci: kconfig: fix incorrect selects
References: <CA+V-a8sMTqU4PkxZ8_EK5yNY1S22G2G=7-bs5j31Umi_Dt97gQ@mail.gmail.com> <1363004536-27314-1-git-send-email-nsekhar@ti.com> <CA+V-a8vaNzio4RYqq8xwe=bOS0F+2t_mkwDWcQ99GbChC97Ayg@mail.gmail.com>
In-Reply-To: <CA+V-a8vaNzio4RYqq8xwe=bOS0F+2t_mkwDWcQ99GbChC97Ayg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3/12/2013 10:44 AM, Prabhakar Lad wrote:
> Hi Sekhar,
> 
> Thanks for the patch! few nits below
> 
> also version number for patch is missing as this should have been v2 :)

Missed that, sorry.

> BTW this patch still is not  present in media list.

Not sure what is happening there. Its an open list as far as I can see
and there is no message I am getting back from list. Most probably vger
thinks I am spamming, but I am not sure why.

>>
>>  config VIDEO_DAVINCI_VPBE_DISPLAY
>>         tristate "DM644X/DM365/DM355 VPBE HW module"
> why not change this to 'TI DaVinci VPBE Video Display' as done for vpif ?

Okay, will do. I would like to remind that I have not tested this patch
(not loaded the modules and connected a video device). If you can get
some testing done on this it will be great.

Thanks,
Sekhar
