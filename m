Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab1HTOU4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 10:20:56 -0400
Message-ID: <4E4FC2BE.4070409@redhat.com>
Date: Sat, 20 Aug 2011 07:20:46 -0700
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH 6/6] EM28xx - don't sleep on disconnect
References: <1313847960.1685.YahooMailClassic@web121706.mail.ne1.yahoo.com>
In-Reply-To: <1313847960.1685.YahooMailClassic@web121706.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2011 06:46, Chris Rankin escreveu:
> --- On Sat, 20/8/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrot
>>
>> This will cause an OOPS if dvb->fe[n] == NULL.
>>
> 
> OK, that's trivially fixable. I'll send you an updated patch. Is it safe to assume that dvb->fe[0] at least will always be non-NULL?

No, it isn't. The dvb initialization may fail or the device can be analog only,
but somebody might manually load em28xx-dvb (or two devices were plugged).

Regards,
Mauro
