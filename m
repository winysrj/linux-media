Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab2DSUqJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Apr 2012 16:46:09 -0400
Message-ID: <4F90798B.5000709@redhat.com>
Date: Thu, 19 Apr 2012 17:46:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org
Subject: Re: [media] fintek-cir: add support for newer chip version
References: <20120419172510.GA14649@elgon.mountain> <20120419204116.GA5165@redhat.com>
In-Reply-To: <20120419204116.GA5165@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-04-2012 17:41, Jarod Wilson escreveu:
> On Thu, Apr 19, 2012 at 08:25:10PM +0300, Dan Carpenter wrote:
>> Hi Mauro,
>>
>> The patch 83ec8225b6ae: "[media] fintek-cir: add support for newer 
>> chip version" from Feb 14, 2012, leads to the following warning:
>> drivers/media/rc/fintek-cir.c:200 fintek_hw_detect()
>> 	 warn: known condition '1032 != 2052'
>>
>> drivers/media/rc/fintek-cir.c
>>    197          /*
>>    198           * Newer reviews of this chipset uses port 8 instead of 5
>>    199           */
>>    200          if ((chip != 0x0408) || (chip != 0x0804))
>>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> One of these conditions is always true.
>>
>> Probably it should it be:
>> 		if ((chip == 0x0408) || (chip == 0x0804))
>> or:
>> 		if ((chip != 0x0408) && (chip != 0x0804))
> 
> Reasonably sure the latter case would be the proper one there.

Yes. The information that I have is that Fintek product 0x0408(F71809) and 0x0804(F71855)
use logical device 5 and other chip ids use logical device 8.
> 
> 
>> depending one if those are the newer or the older chipsets.  I googled
>> for it a bit and then decided to just email you.  :P
>>
>>    201                  fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV2;
>>    202          else
>>    203                  fintek->logical_dev_cir = LOGICAL_DEV_CIR_REV1;
>>    204  
>>
>> regards,
>> dan carpenter
>>
> 

Care to prepare us a patch in order to fix it?

Thank you!
Mauro
