Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2846 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3LRHch (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 02:32:37 -0500
Message-ID: <52B14F73.6010403@xs4all.nl>
Date: Wed, 18 Dec 2013 08:32:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC v3 5/7] v4l: enable some IOCTLs for SDR receiver
References: <1387231688-8647-1-git-send-email-crope@iki.fi> <1387231688-8647-6-git-send-email-crope@iki.fi> <52AFFEA3.7010200@xs4all.nl> <52B07E86.1030100@iki.fi>
In-Reply-To: <52B07E86.1030100@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/17/2013 05:40 PM, Antti Palosaari wrote:
> On 17.12.2013 09:34, Hans Verkuil wrote:
>> On 12/16/2013 11:08 PM, Antti Palosaari wrote:
>>> +	} else if (is_sdr) {
> 
>>> +
>>> +		if (is_rx) {
>>> +			SET_VALID_IOCTL(ops, VIDIOC_ENUMINPUT, vidioc_enum_input);
>>> +			SET_VALID_IOCTL(ops, VIDIOC_G_INPUT, vidioc_g_input);
>>> +			SET_VALID_IOCTL(ops, VIDIOC_S_INPUT, vidioc_s_input);
>>
>> Why would you want to enable these? Normal radio devices should never use
>> these, so why would sdr devices?
> 
> I though it might be good idea to select possible antenna input. I have 
> one rtl2832u prototype which has 2 physical antenna connector, but on 
> the real life input selection is not needed even on that case as 
> antennas are hardwired to different tuner inputs => selection is done 
> according to frequency. Almost all modern silicon tuners has multiple 
> inputs, whilst device has only one physical antenna connector.
> 
> All-in-all, it is not needed now and I can remove it without any noise 
> if you wish. It is trivial to add later if really needed.

Please remove it. If we need antenna input selection in the future, then
we have to look at this again.

Regards,

	Hans

