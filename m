Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:47159 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZH0F6a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 01:58:30 -0400
Received: from localhost.localdomain ([76.94.241.155])
          by cdptpa-omta02.mail.rr.com with ESMTP
          id <20090827055830343.QNBA6096@cdptpa-omta02.mail.rr.com>
          for <linux-media@vger.kernel.org>;
          Thu, 27 Aug 2009 05:58:30 +0000
Message-ID: <4A961F36.2060907@ca.rr.com>
Date: Wed, 26 Aug 2009 22:52:54 -0700
From: Dan Taylor <dan.taylor2@ca.rr.com>
Reply-To: danieltaylor@acm.org
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Can ir polling be turned off in cx88 module for Leadtek
 1000DTV card?
References: <357341.28380.qm@web112510.mail.gq1.yahoo.com> <1251329402.5232.6.camel@palomino.walls.org> <Pine.LNX.4.58.0908262102280.11911@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0908262102280.11911@shell2.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Trent Piepho wrote:
> On Wed, 26 Aug 2009, Andy Walls wrote:
>> On Wed, 2009-08-26 at 07:33 -0700, Dalton Harvie wrote:
>>>   If there isn't, would it be a good idea?
>> Maybe.
>>
>>> Thanks for any help.
>>
>> Try this.  It adds a module option "noir" that accepts an array of
>> int's.  For a 0, that card's IR is set up as normal; for a 1, that
>> card's IR is not initialized.
>>
>> 	# modprobe cx88 noir=1,1
> 
> I think this is a good idea.  I was going to do someting similar
> to stop the excessive irqs from my cx88 cards, which don't
> even have remote receivers.
> 
> I haven't tried, but maybe it is possible to only turn on polling when the
> event device is opened.

Excellent idea.  I did something similar for a pseudo-SCSI device, where I
only polled if there was a command outstanding.

If no one else wants to take it on, I have a pcHDTV-3000 and -5000 and can
get a Leadtek something to work with.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
