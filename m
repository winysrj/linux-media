Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54627 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZJXQbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 12:31:55 -0400
Received: by pzk1 with SMTP id 1so291184pzk.33
        for <linux-media@vger.kernel.org>; Sat, 24 Oct 2009 09:32:00 -0700 (PDT)
Message-ID: <4AE32BFD.1090000@gmail.com>
Date: Sun, 25 Oct 2009 00:31:57 +0800
From: "David T. L. Wong" <davidtlwong@gmail.com>
MIME-Version: 1.0
To: v4l-dvb <linux-media@vger.kernel.org>
Subject: Re: Details about DVB frontend API
References: <20091022211330.6e84c6e7@hyperion.delvare>
In-Reply-To: <20091022211330.6e84c6e7@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> Hi folks,
> 
> I am looking for details regarding the DVB frontend API. I've read
> linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
> FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
> commands return, however it does not give any information about how the
> returned values should be interpreted (or, seen from the other end, how
> the frontend kernel drivers should encode these values.) If there
> documentation available that would explain this?
> 
> For example, the signal strength. All I know so far is that this is a
> 16-bit value. But then what? Do greater values represent stronger
> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
> returned value meaningful even when FE_HAS_SIGNAL is 0? When
> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
> well-defined meanings, or is it arbitrary and each driver can have its
> own scale? What are the typical use cases by user-space application for
> this value?
> 
> That's the kind of details I'd like to know, not only for the signal
> strength, but also for the SNR, BER and UB. Without this information,
> it seems a little difficult to have consistent frontend drivers.
> 
> Thanks,

Hi all,

   I am a bit late in this discussion.

   I just want to raise out a problem of the current architecture of FE 
+ tuner.

   Indeed, the actual "Signal Strength" can only be get from tuner. 
Tuner has amplifier internally and AGC. So demod can never know the 
accurate signal strength. Demod only roughly knows signal-to-noise ratio.

   Correct me if I am wrong that I found FE == Demod in current code.
Thus, asking FE to report the signal strength is not appropriate.

   To achieve reporting actual signal strength, in commercial 
proprietary code, it is a combination of readings from tuner + demod. 
Which in turn,
should sit in card/dongle specific code.

Regards,
David T.L. Wong
