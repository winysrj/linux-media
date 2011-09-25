Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab1IYLgD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 07:36:03 -0400
Message-ID: <4E7F121C.2060601@redhat.com>
Date: Sun, 25 Sep 2011 08:35:56 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: doronc@siano-ms.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH  1/17]DVB:Siano drivers - Adding LKM for handling SPI
 connected devices.
References: <1316514650.5199.79.camel@Doron-Ubuntu>  <4E7CEA0E.6010907@redhat.com> <1316946324.13386.5.camel@Doron-Ubuntu>
In-Reply-To: <1316946324.13386.5.camel@Doron-Ubuntu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-09-2011 07:25, Doron Cohen escreveu:
> On Fri, 2011-09-23 at 17:20 -0300, Mauro Carvalho Chehab wrote:
>> Em 20-09-2011 07:30, Doron Cohen escreveu:
>>> Hi,
>>> It took a long time to merge all the changes in kernel.org with Siano
>>> sources which were updated in a different repository for the last couple
>>> of years.
>>> I have made all the changes in small steps seperated to functional
>>> reasons.
>>> First patch is actually adding new kernel object which handles SPI
>>> connection and used the spidrv of the kernel.
>>> module is used mainly in android platforms but is a pure LKM works with
>>> siano modules stack.
>>>
>>> Thanks,
>>> Doron Cohen

> Hi Mauro,
> Thanks for your response.
> I am going over your comments and changing my patches according to your
> comments. Also running the checkpatch script and remove all errors and
> warnings.

Thanks!
> 
> Please advice what would be the right way to continue:
> 1. Reply each patch and put the new corrected patch below the old
> commented patch.
> or
> 2. Open a new thread with the corrected patch.

What most developers do is to argument against my review when needed, 
using the existing thread. Then, they open a [PATCH v2] thread with
the new patchset.

Regards,
Mauro
