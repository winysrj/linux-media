Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933349Ab1LFMZg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 07:25:36 -0500
Message-ID: <4EDE09B7.9010103@redhat.com>
Date: Tue, 06 Dec 2011 10:25:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stefan Ringel <linuxtv@stefanringel.de>,
	linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: bugfix interrupt reset
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de> <1322509580-14460-3-git-send-email-linuxtv@stefanringel.de> <20111205072131.GB7341@avionic-0098.mockup.avionic-design.de> <4EDCB33E.8090100@redhat.com> <20111205153800.GA32512@avionic-0098.mockup.avionic-design.de> <4EDD0BBF.3020804@redhat.com> <4EDD235A.9000100@stefanringel.de> <4EDD268E.9010603@redhat.com> <20111206065119.GA26724@avionic-0098.mockup.avionic-design.de> <20111206081200.GA8756@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20111206081200.GA8756@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06-12-2011 06:12, Thierry Reding wrote:
> * Thierry Reding wrote:
>> * Mauro Carvalho Chehab wrote:
>>> That means that all we need is to get rid of TM6000_QUIRK_NO_USB_DELAY.
>>
>> I've just reviewed my patches again and it seems that no-USB-delay quirk
>> patch was only partially applied. The actual location where it was introduced
>> was in tm6000_read_write_usb() to allow the msleep(5) to be skipped, which on
>> some devices isn't required and significantly speeds up firmware upload. So I
>> don't think we should get rid of it.
>>
>> If it helps I can rebase the code against your branch (which one would that
>> be exactly?) and resend the rest of the series.
>
> Looking more closely, I think my original patch was applied wrongly. If you
> look at the original patch:
>
> 	http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/37552
>
> and look at the applied version in this commit:
>
> 	42845708363fc92a190f5c47e6fe750e3919f867
>
> Then you see that the hunk from the tm6000_read_write_usb() function was
> applied to the tm6000_reset() function instead.

Hmmm... probably merge conflicts. It is rare, but such things sometimes happen, if
two functions are very similar, and there were enough changes on a driver for the
patch logic to do the wrong thing.

In any case, please send me the patch again, against my tree.

Thanks,
Mauro

>
> Thierry

