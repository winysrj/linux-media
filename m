Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx06.syd.iprimus.net.au ([210.50.76.235]:4048 "EHLO
	mx06.syd.iprimus.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZJWFVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 01:21:17 -0400
From: Mike Booth <mike_booth76@iprimus.com.au>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: Details about DVB frontend API
Date: Fri, 23 Oct 2009 16:11:19 +1100
Cc: LMML <linux-media@vger.kernel.org>
References: <20091022211330.6e84c6e7@hyperion.delvare>
In-Reply-To: <20091022211330.6e84c6e7@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910231611.19861.mike_booth76@iprimus.com.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 23 October 2009 06:13:30 Jean Delvare wrote:
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

I have tried on two occasions to engage the the author of my particular driver 
as to how to implement a patch and use femon with no response.

Its good that there is some movement at last which might get a result.

I've said before I don't really care too much about spot on accuracy
but rather a scale that increases as you get closer to a lock. I can imagine 
there are loads of users out there who rely on the output of things like 
femon and vdr-rotor to tune their equipment and with S2 cards like both of 
mine they are knackered so to speak.


Mike
