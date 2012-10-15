Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59263 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2JOOzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 10:55:38 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm2so137886wib.1
        for <linux-media@vger.kernel.org>; Mon, 15 Oct 2012 07:55:37 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: linux-media@vger.kernel.org
Subject: Re: Sony PlayTV: tuning on second tuner causing reception issues on first tuner
Date: Mon, 15 Oct 2012 16:55:34 +0200
Message-ID: <2728593.03MnPe1ro8@dibcom294>
In-Reply-To: <CAG5Tc=Wk5GV0dSNtFAuD1ffjmCZ02rfM_fk9iuhJUhN1QTXpkw@mail.gmail.com>
References: <CAG5Tc=Wk5GV0dSNtFAuD1ffjmCZ02rfM_fk9iuhJUhN1QTXpkw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Torgeir,

On Sunday 14 October 2012 00:25:26 Torgeir Veimo wrote:
> When background EIT scanning is enabled on my VDR setup, I am getting
> signal disruption about every 20-21 seconds, with my sony playtv USB dual
> DVB-T tuner.

In the VDR-ML-thread you said that you have 2 of those devices?

I could get my hands on the information which is date 3-4 years ago when the 
device was designed and in fact the problem you're describing existed at 
that time. It was fixed by hardware and normally should not appear in end-
user's products. However as I understand the fix can easily fail if the 
production-site a) does not  know that this problem exists and thus does not 
test it or b) doesn't care. Rumors say, that the prod-site has been 
transferred from France to China. If that is true or if your device is 
simply a runner or anything else is not clear as of now.

When did you purchase this device? If it was recently, there is a fair 
chance that exchanging it will result in a working device.

> 
> This seems to be caused by the second tuner retuning in the
> background. I've heard that the nova-t 500 cards can have issues with
> disruption when the second tuner on a card is tuning. Is this the same
> type of problem?

Most likely. No complete software-fix available.

regards,
--
Patrick 

Kernel Labs Inc.
http://www.kernellabs.com/
