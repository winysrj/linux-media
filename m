Return-path: <mchehab@pedra>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:53268 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1E2ASc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 20:18:32 -0400
Subject: Re: [PATCH] [media] lirc_dev: store cdev in irctl, up maxdevs
References: <1306526466-18717-1-git-send-email-jarod@redhat.com> <1306600961.8085.15.camel@localhost>
Content-Transfer-Encoding: 7bit
From: Jarod Wilson <jwilson@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
In-Reply-To: <1306600961.8085.15.camel@localhost>
Message-Id: <BB9DD5B3-5F95-4F7F-9660-B0CDEC9856FB@redhat.com>
Date: Sat, 28 May 2011 20:18:30 -0400 (EDT)
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jarod Wilson <jarod@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On May 28, 2011, at 4:41 PM, Andy Walls <awalls@md.metrocast.net> wrote:

> On Fri, 2011-05-27 at 16:01 -0400, Jarod Wilson wrote:
>> Store the cdev pointer in struct irctl, allocated dynamically as needed,
>> rather than having a static array. At the same time, recycle some of the
>> saved memory to nudge the maximum number of lirc devices supported up a
>> ways -- its not that uncommon these days, now that we have the rc-core
>> lirc bridge driver, to see a system with at least 4 raw IR receivers.
>> (consider a mythtv backend with several video capture devices and the
>> possible need for IR transmit hardware).
>> 
>> Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> ---
>> drivers/media/rc/lirc_dev.c |   33 ++++++++++++++++++++++++---------
>> include/media/lirc_dev.h    |    2 +-
>> 2 files changed, 25 insertions(+), 10 deletions(-)
>> 
>> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
>> index fd237ab..9e79692 100644
>> --- a/drivers/media/rc/lirc_dev.c
>> +++ b/drivers/media/rc/lirc_dev.c
>> 
...
>> 
>> +    cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
> 
>    if (cdev == NULL) 
>        
> 
>>    if (d->fops) {
>>        cdev_init(cdev, d->fops);
> 
>       generate_oops();
> 
> ;)

D'oh, rookie mistake! I'll fix that right up... Thanks for lookin'.


-- 
Jarod Wilson
jarod@redhat.com

