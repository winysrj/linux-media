Return-path: <linux-media-owner@vger.kernel.org>
Received: from 18.mo3.mail-out.ovh.net ([87.98.172.162]:51769 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342Ab1KGPiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2011 10:38:15 -0500
Received: from mail632.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo3.mail-out.ovh.net (Postfix) with SMTP id 18D2B101C1B2
	for <linux-media@vger.kernel.org>; Mon,  7 Nov 2011 16:19:01 +0100 (CET)
Received: from [127.0.0.1] (localhost.localdomain [127.0.0.1])
	by ventoso.org (Postfix) with ESMTP id 54955C26BD5
	for <linux-media@vger.kernel.org>; Mon,  7 Nov 2011 16:13:05 +0100 (CET)
Message-ID: <4EB7F57E.4060303@ventoso.org>
Date: Mon, 07 Nov 2011 16:13:02 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
CC: linux-media Mailing List <linux-media@vger.kernel.org>
Subject: Re: femon signal strength
References: <4EA78E3C.2020308@lockie.ca> <CAGoCfiwS=O75uyaaueNSrq275MS9eednR+Y=yrgsJo0XaExRKA@mail.gmail.com> <4EA86366.1020906@lockie.ca> <CAGoCfiww_5pF_S3M_mpN4gk1qqLYn7H7PPcieZXZNnjvK-RHHA@mail.gmail.com> <4EA86668.6090508@lockie.ca> <20111105111050.5b8762fa@grobi> <CAGoCfiwC+7pkY6ZchySBYRkyY1XjFjKeJYQEPTc2ZiBN-pdoyw@mail.gmail.com> <20111106141515.5b56a377@grobi> <CAGoCfixoOwZumohwJrLVKhfpUNGYwbD9uSq7nM0GhqriOx0FxA@mail.gmail.com> <20111106205907.47b9102b@grobi> <4EB7B75B.70004@linuxtv.org>
In-Reply-To: <4EB7B75B.70004@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Al 07/11/2011 11:47, En/na Andreas Oberritter ha escrit:
> I didn't receive Devin's mail, so I'm replying to this one instead, see
> below:

[...]
> Quoting myself from three years ago, I propose to add an interface to
> read SNR in units of db/100:

A previous version of the dvb api specified the unit of snr as db/1000000

http://linuxtv.org/downloads/legacy/old/linux_dvb_api-20020304.pdf

page 55, FE_READ_SIGNAL_STRENGTH

"The signal-to-noise ratio, as a multiple of 10E-6 dB, is stored into *snr.
Example: a value of 12,300,000 corresponds to a signal-
to-noise ratio of 12.3 dB."

It also defined the unit for ber (multiple of 10E-9).

However it was dropped from subsequent revisions, I don't know why.

Bye
-- 
Luca
