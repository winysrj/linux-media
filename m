Return-path: <mchehab@gaivota>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44407 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab0L2Lfu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 06:35:50 -0500
Received: by fxm20 with SMTP id 20so10378032fxm.19
        for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 03:35:49 -0800 (PST)
Message-ID: <4D1B1D11.6030505@fliegl.de>
Date: Wed, 29 Dec 2010 12:35:45 +0100
From: Deti Fliegl <deti@fliegl.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Felipe Sanches <juca@members.fsf.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] dabusb: Move it to staging to be deprecated
References: <4D19037B.6060904@redhat.com> <201012291137.49153.hverkuil@xs4all.nl> <4D1B1532.60606@fliegl.de> <201012291224.25864.hverkuil@xs4all.nl>
In-Reply-To: <201012291224.25864.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 12/29/10 12:24 PM, Hans Verkuil wrote:
 >> No, it should support the Terratec hardware as well but it's outdated
 >> and unstable. Therefor I agreed to remove the driver from the current
 >> kernel as I am not willing to continue support for the code.
 >
 > I don't think it supports the Terratec hardware since the list of USB ids
 > doesn't include the Terratec products:
Yes you are right - there you see - our driver is quite different - out 
latest changes are of october 2010 - and the kernel driver is somehow 
stone aged.

 > Unless someone will pick up this source code and starts to work with 
us on
 > designing an API it will probably be forgotten :-(
 >
 > As far as I can tell (please correct me if I am wrong) the hardware 
either no
 > longer available or very hard to get hold off.
The product has been discontinued a couple of years ago. AFAIK about 50k 
to 100k pieces have been sold.

 > I did see that Terratec still sells some DAB receivers, but they are 
all based
 > on different hardware.
Yes you are right. We currently do not develop any DAB products and I 
don't think there will be DAB Linux support from other companies. DAB 
and even DAB+ is dead.

Deti
