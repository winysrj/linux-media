Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-190.synserver.de ([212.40.185.190]:1047 "EHLO
	smtp-out-190.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423530Ab3FUROR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 13:14:17 -0400
Message-ID: <51C489F7.6070105@metafoo.de>
Date: Fri, 21 Jun 2013 19:14:31 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] tvp514x: Fix init seqeunce
References: <1371306876-8596-1-git-send-email-lars@metafoo.de> <CA+V-a8uUEcoh2bbpUP=Oo8Pj-1yX8VWS7z9m_kOgyzxfMwQ-Ow@mail.gmail.com> <CA+V-a8tgrLgeuQ83eRQkW6OeyBvCYzRD5k4xjnPwdne7hbCuWQ@mail.gmail.com>
In-Reply-To: <CA+V-a8tgrLgeuQ83eRQkW6OeyBvCYzRD5k4xjnPwdne7hbCuWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/2013 02:27 PM, Prabhakar Lad wrote:
> Hi Lars-Peter,
> 
> On Sun, Jun 16, 2013 at 3:41 PM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>> Hi Lars-Peter,
>>
>> Thanks for the patch.
>>
>> On Sat, Jun 15, 2013 at 8:04 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> client->driver->id_table will always point to the first entry in the device id
>>> table. So all devices will use the same init sequence. Use the id table entry
>>> that gets passed to the driver's probe() function to get the right init
>>> sequence.
>>>
>> The patch looks OK, but it causes following two warnings,
>>
>> drivers/media/i2c/tvp514x.c: In function 'tvp514x_s_stream':
>> drivers/media/i2c/tvp514x.c:868: warning: unused variable 'client'
>> drivers/media/i2c/tvp514x.c: In function 'tvp514x_probe':
>> drivers/media/i2c/tvp514x.c:1092: warning: assignment makes pointer
>> from integer without a cast
>>
> Do you plan to post a v2 ? or shall I take care of it ?
> 
> Regards,
> --Prabhakar Lad

I'll send a v2 soon.

- Lars
