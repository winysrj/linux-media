Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199Ab1LATSe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Dec 2011 14:18:34 -0500
Message-ID: <4ED7D306.6040603@redhat.com>
Date: Thu, 01 Dec 2011 17:18:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: damateem <damateem4@gmail.com>
CC: linux-media list <linux-media@vger.kernel.org>
Subject: Re: Debug output
References: <4ED6CE53.7010806@gmail.com> <4ED7CF04.8050906@gmail.com>
In-Reply-To: <4ED7CF04.8050906@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01-12-2011 17:01, damateem wrote:
> Ok, if I set debug as follows
>
> vfd->debug =V4L2_DEBUG_IOCTL | V4L2_DEBUG_IOCTL_ARG;
>
> I can see the debug trace in dmesg, but this doesn't seem like the
> correct way to set the flags.

In general, what it is none is to add a debug modprobe parameter that
would enable those logs with something like:

static unsigned int debug;
module_param(debug, int, 0644);
MODULE_PARM_DESC(debug, "debug message mask (1 = ioctl, 2 = ioctl args)");


...
	vfd->debug = debug;

>
> What is the typical method of setting these debug flags?
>
> Is this the best place to ask these type of questions?
>
> Thanks,
> David
>
>
> On 11/30/2011 7:46 PM, damateem wrote:
>> There are a fair number of debug print statements in the V4L2 code. How
>> do I turn those on?
>>
>> For instance, I'd like the following code to print
>>
>> if ((vfd->debug&  V4L2_DEBUG_IOCTL)&&
>>                  !(vfd->debug&  V4L2_DEBUG_IOCTL_ARG)) {
>>          v4l_print_ioctl(vfd->name, cmd);
>>          printk(KERN_CONT "\n");
>>      }
>>
>> so I can trace the IOCTL calls.
>>
>> Thanks,
>> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

