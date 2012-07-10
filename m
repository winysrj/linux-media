Return-path: <linux-media-owner@vger.kernel.org>
Received: from stevekez.vm.bytemark.co.uk ([80.68.91.30]:35536 "EHLO
	stevekerrison.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416Ab2GJQw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jul 2012 12:52:29 -0400
Message-ID: <4FFC5B7A.5060708@stevekerrison.com>
Date: Tue, 10 Jul 2012 17:42:34 +0100
From: Steve Kerrison <steve@stevekerrison.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>
Subject: Re: comments for DVB LNA API
References: <4FFC5B4E.8080903@stevekerrison.com>
In-Reply-To: <4FFC5B4E.8080903@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

On 10/07/12 17:20, Antti Palosaari wrote:
> I am looking how to implement LNA support for the DVB API.
>
> What we need to be configurable at least is: OFF, ON, AUTO.
>
> There is LNAs that support variable gain and likely those will be
> sooner or later. Actually I think there is already LNAs integrated to
> the RF-tuner that offers adjustable gain. Also looking to NXP catalog
> and you will see there is digital TV LNAs with adjustable gain.
>
> Coming from that requirements are:
> adjustable gain 0-xxx dB
> LNA OFF
> LNA ON
> LNA AUTO
>
> Setting LNA is easy but how to query capabilities of supported LNA
> values? eg. this device has LNA which supports Gain=5dB, Gain=8dB, LNA
> auto?
Without having a sample of device capabilities this question may be
irrelevant, but what if the gain is somewhat continuiously configurable
vs. discretized? For example can some be configured just for 5,8 and 11,
whilst some might have some 8-bit value that controls gain between 5 and 11?
>
> LNA ON (bypass) could be replaced with Gain=0 and LNA ON with Gain>0,
> Gain=-1 is for auto example.

How should the API handle differences between the specified gain and the
capabilities of the LNA? Round to nearest possible config if it's within
the operating range; return error if out of range?
>
>
>
> regards
> Antti
>

-- 
Steve Kerrison MEng Hons.
http://www.stevekerrison.com/






