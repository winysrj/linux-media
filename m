Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab1IWPMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 11:12:19 -0400
Message-ID: <4E7CA1CD.50309@redhat.com>
Date: Fri, 23 Sep 2011 12:12:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Stuart Morris <stuart_morris@talk21.com>,
	linux-media@vger.kernel.org
Subject: Re: em28xx PCTV 290e patches
References: <1316767965.1148.YahooMailClassic@web86705.mail.ird.yahoo.com> <4E7C51A7.9020209@yahoo.com>
In-Reply-To: <4E7C51A7.9020209@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-09-2011 06:30, Chris Rankin escreveu:
> Hi Stuart,
> 
> On 23/09/11 09:52, Stuart Morris wrote:
>> I have a PCTV 290e and have been watching closely the updates to the Linux media
>> tree for this device. Thanks for addressing the issues with the 290e driver, I am
>> now able to use my 290e for watching UK FreeviewHD with a good degree of success.
> 
> No problems, although I think Mauro has been working on the locking problem as well :-).
> 
>> I have a question regarding some patches you requested a while back that have
>> yet to be applied to the media tree.
>> These patches are:
>> http://www.spinics.net/lists/linux-media/msg36799.html
>> http://www.spinics.net/lists/linux-media/msg36818.html
> 
> Yes, I have noticed this. My advice would be to apply the first patch that remove the em28xx_remove_from_devlist() function (and the race condition that it creates), but not the second patch because I don't think it's compatible with Mauro's work.
> 
> My other patches have *slowly* been added to the queue for 3.2; I am still waiting to see if this patch will join the others before resubmitting it.

Chris,

Please, re-submit the ones that are pertinent. Some of your patches are
missing your SOB, and, due to the patchwork.kernel.org outage, I lost
part of my control about what patches got obsoleted, especially since you
didn't add a version number to the patches you've submitted. In general, when
people re-submit a patch series, they tag the new series as [PATCHv2] or
something, to help maintainers to discard the old stuff ;)
> 
> Cheers,
> Chris
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

