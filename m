Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2640 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbaDKKgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 06:36:05 -0400
Message-ID: <5347C57B.7000207@xs4all.nl>
Date: Fri, 11 Apr 2014 12:35:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Cookson - IT <it@sca-uk.com>, linux-media@vger.kernel.org
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com>
In-Reply-To: <5347BDDE.6080208@sca-uk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/2014 12:03 PM, Steve Cookson - IT wrote:
> Hi Hans,
> 
> Thanks for this, I'll do as you suggested.
> 
> On 11/04/14 10:45, Hans Verkuil wrote:
>> I have serious doubts whether this is actually supported. I see no mention of
>> that board in the cx23885 driver. I wonder if there is a mixup between the
>> ImpactVCB (which IS supported) and the ImpactVCB-e.
> Do you think there is another internal card out there that would do the 
> job of capturing raw SD video?
> 
> What would you recommend.

Actually, I would recommend that you try playing with the 'card=' option to
see if you can get something that works. I suspect that adding support for
this card isn't hard.

Alternatively, you can wait. I've ordered this card myself (it's about time I
start cleaning up the cx23885 driver, so some extra hardware to test with won't
hurt) so once I have it I'll work on adding support for it to the cx23885
driver. The problem is that it has to be ordered, so it may take some time
before it arrives.

There aren't all that many alternatives available for PCIe (PCI is easier). You
can look at the list of supported cards in cx23885-cards.c and see if you can
get any of those other cards.

Regards,

	Hans

> 
> I'm currently using the Dazzle DVC100, stripping the case off and 
> installing it internally with cable ties.   It's just a bit basic. I'd 
> like something a bit more professional like a half-height PCIe board.  
> Which is why I selected the ImpactVCB-e, but really I have no attachment 
> to it.
> 
> Regards
> 
> Steve.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

