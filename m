Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab0AKIbF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 03:31:05 -0500
Message-ID: <4B4A6F5A.2070003@redhat.com>
Date: Mon, 11 Jan 2010 01:22:50 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca_sunplus problem: more than one device is created
References: <4B4A0268.20104@freemail.hu> <20100110203548.23a07ce2@tele>
In-Reply-To: <20100110203548.23a07ce2@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/10/2010 08:35 PM, Jean-Francois Moine wrote:
> On Sun, 10 Jan 2010 17:38:00 +0100
> Németh Márton<nm127@freemail.hu>  wrote:
>
>> I tried the gspca_sunplus driver from
>> http://linuxtv.org/hg/~jfrancois/gspca/ rev 13915 on top of Linux
>> kernel 2.6.32. When I plug the Trust 610 LCD PowerC@m Zoom device in
>> webcam mode (0x06d6:0x0031) then two devices are created: /dev/video0
>> and /dev/video1:
> 	[snip]
>
> OK, this is a bug. I did not imagine that some webcams had the same
> interface class for two different devices. I am fixing it.
>

JF,

You did not mark this as high priority, still it should go into 2.6.33.
can you please send a mail to Mauro asking for this ?

Regards,

Hans
