Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:34778 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbCPXQI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 19:16:08 -0400
Message-ID: <55076436.3000401@southpole.se>
Date: Tue, 17 Mar 2015 00:16:06 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC][PATCH] rtl2832: PID filter support for slave demod
References: <55075559.50100@southpole.se> <55075FDC.1030507@iki.fi>
In-Reply-To: <55075FDC.1030507@iki.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/16/2015 11:57 PM, Antti Palosaari wrote:
> On 03/17/2015 12:12 AM, Benjamin Larsson wrote:
>> Is this structure ok for the slave pid implementation? Or should there
>> be only one filters parameter? Will the overlaying pid filter framework
>> properly "flush" the set pid filters ?
>>
>> Note that this code currently is only compile tested.
>
> I am fine with it.
>
> byw. Have you tested if your QAM256 (DVB-C or DVB-T2) stream is valid
> even without a PID filtering? IIRC mine stream is correct and PID
> filtering is not required (but surely it could be implemented if you wish).
>
> regards
> Antti
>

DVB-C seems fine and one of my DVB-T2 muxes is fine also. But one other 
DVB-T2 mux completely fails. It could be the reception but it might be 
that it needs pid filtering. I do get small disturbances on my DVB-C 
muxes. Will report back if pid filtering makes things better or not.

MvH
Benjamin Larsson
