Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3315 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaCJPgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 11:36:37 -0400
Message-ID: <531DDBF9.5060803@xs4all.nl>
Date: Mon, 10 Mar 2014 16:36:25 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] rtl2832u_sdr: fixing v4l2-compliance issues
References: <5317B182.8050200@xs4all.nl> <531DDA48.9000702@iki.fi>
In-Reply-To: <531DDA48.9000702@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/10/2014 04:29 PM, Antti Palosaari wrote:
> Moikka Hans!
> 
> On 06.03.2014 01:21, Hans Verkuil wrote:
>> Antti,
>>
>> Attached is a patch that fixed all but one v4l2-compliance error:
>>
>>                  fail: v4l2-test-controls.cpp(295): returned control value out of range
>>                  fail: v4l2-test-controls.cpp(357): invalid control 00a2090c
>>          test VIDIOC_G/S_CTRL: FAIL
>>                  fail: v4l2-test-controls.cpp(465): returned control value out of range
>>                  fail: v4l2-test-controls.cpp(573): invalid control 00a2090c
>>          test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
>>
>> That's the BANDWIDTH control and it returned value 3200000 when the minimum was 6000000.
>> I couldn't trace where that came from in the limited time I spent on it, I expect you
>> can find it much quicker.
> 
> That is because I added native V4L2_CID_RF_TUNER_BANDWIDTH support only 
> for E4000 tuner driver. The others, FC0012, FC0013 and R820T are set via 
> DVB API by rtl2832_sdr driver, which is quite hackish solution. Devices 
> having E4000 works correctly.
> 
> Dunno if it wise to hack rtl2832_sdr and clamp values to valid per tuner 
> or leave it as it is. Adding V4L2_CID_RF_TUNER_BANDWIDTH to those 3 
> tuner drivers is also quite trivial...

I recommend whatever is the best long-term solution :-)

It's good practice to fix such compliance errors. One reason is that v4l2-compliance
generally stops testing whatever ioctl it is testing once it finds a problem, so there
may be other failures lurking behind this one that v4l2-compliance won't find.

The other reason is that, well, it's a bug! So it should be fixed anyway.

Regards,

	Hans
