Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm12-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.51]:37178 "HELO
	nm12-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751383Ab1HTNqB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 09:46:01 -0400
Message-ID: <1313847960.1685.YahooMailClassic@web121706.mail.ne1.yahoo.com>
Date: Sat, 20 Aug 2011 06:46:00 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [PATCH 6/6] EM28xx - don't sleep on disconnect
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
In-Reply-To: <4E4FA5E0.8050606@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--- On Sat, 20/8/11, Mauro Carvalho Chehab <mchehab@redhat.com> wrot
> 
> This will cause an OOPS if dvb->fe[n] == NULL.
> 

OK, that's trivially fixable. I'll send you an updated patch. Is it safe to assume that dvb->fe[0] at least will always be non-NULL?

Cheers,
Chris

