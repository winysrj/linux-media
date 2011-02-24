Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:32474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab1BXTLQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 14:11:16 -0500
Message-ID: <4D66AD51.6090608@redhat.com>
Date: Thu, 24 Feb 2011 16:11:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 5/9 v2] ds3000: clean up in tune procedure
References: <201102020040.49656.liplianin@me.by> <4D66ABAF.5020908@infradead.org>
In-Reply-To: <4D66ABAF.5020908@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-02-2011 16:04, Mauro Carvalho Chehab escreveu:
> Hi Igor,
> 
> Em 01-02-2011 20:40, Igor M. Liplianin escreveu:
>> Variable 'retune' does not make sense.
>> Loop is not needed for only one try.
>> Remove unnecessary dprintk's.
>>
>> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> 
> This patch didn't apply. Please fix and resend.

PS.: I won't try to apply patches 7, 8 and 9, as they are all related to
tune changes. They'll probably fail to apply, and, even if not failing or if
I fix the conflicts, they may be breaking the driver. So, please put them
on your next patch series.

thanks!
Mauro
