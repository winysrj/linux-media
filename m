Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44332 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbbHKCzT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 22:55:19 -0400
Subject: Re: [PATCHv3 12/13] DocBook: fix S_FREQUENCY => G_FREQUENCY
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1438308650-2702-1-git-send-email-crope@iki.fi>
 <1438308650-2702-13-git-send-email-crope@iki.fi> <55C871B9.2080207@xs4all.nl>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <55C96414.3050805@iki.fi>
Date: Tue, 11 Aug 2015 05:55:16 +0300
MIME-Version: 1.0
In-Reply-To: <55C871B9.2080207@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/2015 12:41 PM, Hans Verkuil wrote:
> On 07/31/2015 04:10 AM, Antti Palosaari wrote:
>> It is VIDIOC_G_FREQUENCY which does not use type to identify tuner,
>> not VIDIOC_S_FREQUENCY. VIDIOC_S_FREQUENCY uses both tuner and type
>> fields. One of these V4L API weirdness...
>
> Actually, that's not what this is about. It's about whether g/s_frequency gets/sets
> the frequency for the tuner or the modulator. That has nothing to do with the tuner
> and type fields. The problem described here in the spec is a problem for both G and
> S_FREQUENCY.

ah, now I think I see it. There is no tuner type for FM radio modulator 
- but instead it is capability of tuner type V4L2_TUNER_RADIO. As both 
radio receiver and transmitter has same tuner type it is not possible to 
identify it using tuner type...

regards
Antti

-- 
http://palosaari.fi/
