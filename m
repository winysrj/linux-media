Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51777 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932470AbbENQF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2015 12:05:28 -0400
Message-ID: <5554C7BB.3070300@xs4all.nl>
Date: Thu, 14 May 2015 18:05:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Patrice Levesque <video4linux.wayne@ptaff.ca>
CC: linux-media@vger.kernel.org
Subject: Re: ATI TV Wonder regression since at least 3.19.6
References: <20150511161203.GG3206@ptaff.ca> <55519647.5010007@xs4all.nl> <20150514125607.GA3303@ptaff.ca>
In-Reply-To: <20150514125607.GA3303@ptaff.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2015 02:56 PM, Patrice Levesque wrote:
> 
> Hi Hans,
> 
> 
>> Can you go back to kernel 3.18 and make a small change to the cx88
>> driver: edit drivers/media/pci/cx88/cx88-video.c, search for the
>> function restart_video_queue() (around line 469) and add this line:
> 
> Function isn't used; when compiling I get:
> 
> CC [M]  drivers/media/pci/cx88/cx88-video.o
> drivers/media/pci/cx88/cx88-video.c:415:12: warning: ‘restart_video_queue’ defined but not used [-Wunused-function]

That makes no sense. This function is most definitely used. Can you mail me
your cx88-video.c source?

> 
> I attached my dmesg (truncated, ring buffer must be too small)
> nonetheless.

Did you start a capturing video first before running dmesg? I want to see
if capturing video will generate messages in dmesg.

> 
> 
>> I'd also like to know the exact model of your board. If the
>> 'restart_video_queue' message appears in the kernel log, then I want
>> to see if I can find this card on ebay so I can try to reproduce it
>> myself.
> 
> Part number written on the card is 109-95200-01 - entering that number
> into search engines returns me lots of ebay links.

Hmm, the cards are cheap but all are in the US and they ask steep shipping
costs. Let me see if with your help I can get an idea of what's going on (I
have a suspicion) before buying one of these boards.

Regards,

	Hans

> Is there anything else I can send you that can be useful?
> 
> 
> Thanks,
> 
> 
> 

