Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:60316 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab3ACT1V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jan 2013 14:27:21 -0500
From: Albert Wang <twang13@marvell.com>
To: Nicolas THERY <nicolas.thery@st.com>
CC: Jonathan Corbet <corbet@lwn.net>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Date: Thu, 3 Jan 2013 11:27:11 -0800
Subject: RE: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support
 for marvell-ccic driver
Message-ID: <477F20668A386D41ADCC57781B1F70430D13EA8B26@SC-VEXCH1.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-4-git-send-email-twang13@marvell.com>
 <20121216090305.13e6bca1@hpe.lwn.net>
 <477F20668A386D41ADCC57781B1F70430D13C8CCDE@SC-VEXCH1.marvell.com>
 <50E5C1E2.9090204@st.com>
In-Reply-To: <50E5C1E2.9090204@st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Nicolas

Thank you for your reminder. :)

Happy New Year!

>-----Original Message-----
>From: Nicolas THERY [mailto:nicolas.thery@st.com]
>Sent: Friday, 04 January, 2013 01:38
>To: Albert Wang
>Cc: Jonathan Corbet; g.liakhovetski@gmx.de; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support for marvell-
>ccic driver
>
>
>
>On 2012-12-16 22:51, Albert Wang wrote:
>[...]
>>>>
>>>> +static void mcam_clk_set(struct mcam_camera *mcam, int on)
>>>> +{
>>>> +	unsigned int i;
>>>> +
>>>> +	if (on) {
>>>> +		for (i = 0; i < mcam->clk_num; i++) {
>>>> +			if (mcam->clk[i])
>>>> +				clk_enable(mcam->clk[i]);
>>>> +		}
>>>> +	} else {
>>>> +		for (i = mcam->clk_num; i > 0; i--) {
>>>> +			if (mcam->clk[i - 1])
>>>> +				clk_disable(mcam->clk[i - 1]);
>>>> +		}
>>>> +	}
>>>> +}
>>>
>>> A couple of minor comments:
>>>
>>> - This function is always called with a constant value for "on".  It would
>>>   be easier to read (and less prone to unfortunate brace errors) if it
>>>   were just two functions: mcam_clk_enable() and mcam_clk_disable().
>>>
>> [Albert Wang] OK, that's fine to split it to 2 functions. :)
>>
>>> - I'd write the second for loop as:
>>>
>>> 	for (i = mcal->clk_num - 1; i >= 0; i==) {
>>>
>>>   just to match the values used in the other direction and avoid the
>>>   subscript arithmetic.
>>>
>> [Albert Wang] Yes, we can improve it. :)
>
>Bewar: i is unsigned so testing i >= 0 will loop forever.
>
[Albert Wang] Yes, it looks my original code can work. :)
>[...]

Thanks
Albert Wang
86-21-61092656
