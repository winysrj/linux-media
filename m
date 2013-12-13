Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51316 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab3LMOoI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 09:44:08 -0500
Message-ID: <52AB1D36.8080106@iki.fi>
Date: Fri, 13 Dec 2013 16:44:06 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH RFC 1/2] v4l2: add stream format for SDR receiver
References: <1386867447-1018-1-git-send-email-crope@iki.fi> <1386867447-1018-2-git-send-email-crope@iki.fi> <52AB1B5F.7090804@xs4all.nl>
In-Reply-To: <52AB1B5F.7090804@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the comments Hans!

On 13.12.2013 16:36, Hans Verkuil wrote:
> On 12/12/2013 05:57 PM, Antti Palosaari wrote:
>> +	[V4L2_BUF_TYPE_SDR_RX]             = "sdr-rx",
>

> Make this SDR_CAPTURE and sdr-cap to be consistent with existing naming
> conventions.

>> +		{ V4L2_BUF_TYPE_SDR_RX,               "SDR_RX" }, \
>
> "SDR_CAPTURE"

I will change device name to from RX to CAP/CAPTURE in order to keep it 
like existing devices. I actually thought that name too, but decided to 
use RX (and TX for SDR transmitter) is it sounds more suitable for radio 
devices. But capture is not bad at all.


regards
Antti

-- 
http://palosaari.fi/
