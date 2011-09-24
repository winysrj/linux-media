Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm23-vm1.bullet.mail.ne1.yahoo.com ([98.138.91.50]:22369 "HELO
	nm23-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750832Ab1IXPhU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 11:37:20 -0400
References: <4E7DEF16.6070209@yahoo.com> <4E7DF406.90101@redhat.com>
Message-ID: <1316878639.35873.YahooMailNeo@web121709.mail.ne1.yahoo.com>
Date: Sat, 24 Sep 2011 08:37:19 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [PATCH 0/2] EM28xx patches for 3.2
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <4E7DF406.90101@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

----- Original Message -----

>> BTW, did you implement a different solution for the DVB module trying to retake the dev->lock mutex?
>> Because it looks as if both em28xx_dvb_init() and em28xx_usb_probe() are still calling mutex_lock().

> No, I didn't find any time to look into it. Too much work here...

OK, then I'd probably better resubmit my final patch as well then.

Cheers,
Chris
