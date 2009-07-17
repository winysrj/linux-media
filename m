Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:44537 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbZGQXua (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 19:50:30 -0400
Message-ID: <4A610E3A.3090703@zerezo.com>
Date: Sat, 18 Jul 2009 01:50:18 +0200
From: Antoine Jacquet <royale@zerezo.com>
MIME-Version: 1.0
To: Lamarque Vieira Souza <lamarque@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] Implement V4L2_CAP_STREAMING for zr364xx driver
References: <200907152054.56581.lamarque@gmail.com> <20090716124506.26e7e6b0@pedra.chehab.org> <200907161709.08087.lamarque@gmail.com>
In-Reply-To: <200907161709.08087.lamarque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Lamarque Vieira Souza wrote:
> Em Quinta-feira 16 Julho 2009, Mauro Carvalho Chehab escreveu:
>> Em Wed, 15 Jul 2009 20:54:55 -0300
[...]
>>> +	if (pipe_info->state != 0) {
>>> +		if (usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL))
>>> +			dev_err(&cam->udev->dev, "error submitting urb\n");
>>> +	} else {
>>> +		DBG("read pipe complete state 0\n");
>>> +	}
>> Hmm...  for the usb_submit_urb() call that happens during IRQ context
>> (while you're receiving stream), you need to use:
>>         urb->status = usb_submit_urb(pipe_info->stream_urb, GFP_ATOMIC);
>>
>> otherwise, you may get the errors that Antoine is reporting
> 
> 	Ok, changed to GPF_ATOMIC. Could someone test this for me since I was not 
> able to reproduce this problem? The new patch is here 
> http://bach.metasys.com.br/~lamarque/zr364xx/zr364xx.c-streaming.patch-v4l-
> dvb-20090716 . I upload it to avoid bloating the mailing-list with a 40k 
> patch.

I confirm it fixes the issue.
I will upload the patch to my branch and send a pull request to Mauro.

Thanks and best regards,

Antoine

-- 
Antoine "Royale" Jacquet
http://royale.zerezo.com
