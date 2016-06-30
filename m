Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35834 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcF3N4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 09:56:18 -0400
Received: by mail-vk0-f52.google.com with SMTP id u68so67834946vkf.2
        for <linux-media@vger.kernel.org>; Thu, 30 Jun 2016 06:55:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <790b5e1664c84e806a13143eff1c79b95fb4bf63.1467240152.git.mchehab@s-opensource.com>
References: <0003e025f7664aae1500f084bbd6f7aa5d92d47f.1467240152.git.mchehab@s-opensource.com>
 <790b5e1664c84e806a13143eff1c79b95fb4bf63.1467240152.git.mchehab@s-opensource.com>
From: Steven Toth <stoth@kernellabs.com>
Date: Thu, 30 Jun 2016 09:48:30 -0400
Message-ID: <CALzAhNUdS_aQ+gTHAJ02whAuUcOOpTpJUo33NK7FWYx_EmgSjQ@mail.gmail.com>
Subject: Re: [PATCH 08/10] dvb_frontend: create a new ops to help returning
 signals in dB
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Ira Krufky <mkrufky@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> add a new ops that will allow tuners to better report the
> dB level of its AGC logic to the demod drivers. As the maximum
> gain may vary from tuner to tuner, we'll be reversing the
> logic here: instead of reporting the gain, let's report the
> attenuation. This way, converting from it to the legacy DVBv3
> way is trivial. It is also easy to adjust the level of
> the received signal to dBm, as it is just a matter of adding
> an offset at the demod and/or at the bridge driver.

Mauro,

Have you verified this work with a detailed spectrum analysis study?
If so then please share. For example, by measuring the I/F out of
various tuners in a mix of use cases, with and without the AGC being
driven by any downstream demodulator? Also, taking into consideration
any external LNA variance.

I'm concerned that a tuner AGC Gain is a meaningless measurement and
in practice demodulators don't actually care, and tuners don't
implement their gain reporting capabilities correctly at all.

This feels like a solution to a problem that doesn't exist.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
+1.646.355.8490
