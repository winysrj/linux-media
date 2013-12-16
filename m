Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36337 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab3LPQvF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 11:51:05 -0500
Message-ID: <52AF2F72.7030203@iki.fi>
Date: Mon, 16 Dec 2013 18:50:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/7] V4L2 SDR API
References: <1387037729-1977-1-git-send-email-crope@iki.fi> <52AC8B20.906@iki.fi> <52AC8FD6.2080504@xs4all.nl> <52AC99C1.4050108@iki.fi> <20131215093022.5e6e8d37.m.chehab@samsung.com>
In-Reply-To: <20131215093022.5e6e8d37.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.12.2013 13:30, Mauro Carvalho Chehab wrote:
> Em Sat, 14 Dec 2013 19:47:45 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> On 14.12.2013 19:05, Hans Verkuil wrote:
>>> On 12/14/2013 05:45 PM, Antti Palosaari wrote:

> I didn't like much that now have 3 ways to describe frequencies.
> I think we should latter think on moving the frequency conversion to
> the core, and use u64 with 1Hz step at the internal API, converting all
> the drivers to use it.
>
> IMHO, we should also provide a backward-compatible way that would allow
> userspace to choose to use u64 1-Hz-stepping frequencies.
>
> Of course the changes at the drivers is out of the scope, but perhaps
> we should not apply patch 4/7, replacing it, instead, by some patch that
> would move the frequency size to u64.

Frequency is defined by that structure.

struct v4l2_frequency {
	__u32	tuner;
	__u32	type;	/* enum v4l2_tuner_type */
	__u32	frequency;
	__u32	reserved[8];
};


Is it possible to somehow use reserved bytes to extend value to 64. Then 
change that 1-Hz flag (rename it) to signal it is 64?

Or add some info to that struct itself? Define both frequency and 
frequency64 and use the one which is not zero?

If implementation will not be very complex I could try to do it it the 
same time with other changes.

regards
Antti

-- 
http://palosaari.fi/
