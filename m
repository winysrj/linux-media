Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:54496 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab3BPQkS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 11:40:18 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v2 0/4] saa7134: Add AverMedia A706 AverTV Satellite Hybrid+FM
Date: Sat, 16 Feb 2013 17:39:49 +0100
Cc: linux-media@vger.kernel.org,
	"Michael Krufky =?utf-8?q?=19?=" <mkrufky@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <1359750087-1155-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359750087-1155-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201302161739.49850.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 01 February 2013 21:21:23 Ondrej Zary wrote:
> Add AverMedia AverTV Satellite Hybrid+FM (A706) card to saa7134 driver.
>
> This requires some changes to tda8290 - disabling I2C gate control and
> passing custom std_map to tda18271.
> Also tuner-core needs to be changed because there's currently no way to
> pass any complex configuration to analog tuners.

What's the status of this patch series?

The two tda8290 patches are in Michael's dvb tree.
I've sent an additional clean-up patch (on Mauro's suggestion) for the 
tuner-core change.
I guess that the final AverMedia A706 patch would be easily merged once the 
tda8290 and tuner-core changess are done.

Should I resend something?

-- 
Ondrej Zary
