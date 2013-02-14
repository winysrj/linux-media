Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49724 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934698Ab3BNPxh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 10:53:37 -0500
Message-ID: <511D085A.80009@iki.fi>
Date: Thu, 14 Feb 2013 17:52:58 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
CC: linux-media@vger.kernel.org
Subject: Re: DVB: EOPNOTSUPP vs. ENOTTY in ioctl(FE_READ_UNCORRECTED_BLOCKS)
References: <511CE2BF.8020905@tvdr.de>
In-Reply-To: <511CE2BF.8020905@tvdr.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/14/2013 03:12 PM, Klaus Schmidinger wrote:
> In VDR I use an ioctl() call with FE_READ_UNCORRECTED_BLOCKS on a device
> (using stb0899).
> After this call I check 'errno' for EOPNOTSUPP to determine whether this
> device supports this call. This used to work just fine, until a few months
> ago I noticed that my devices using stb0899 didn't display their signal
> quality in VDR's OSD any more. After further investigation I found that
> ioctl(FE_READ_UNCORRECTED_BLOCKS) no longer returns EOPNOTSUPP, but rather
> ENOTTY. And since I stop getting the signal quality in case any unknown
> errno value appears, this broke my signal quality query function.
>
> Is there a reason why this has been changed?

I changed it in order to harmonize error codes. ENOTTY is correct error 
code for the case IOCTL is not implemented. What I think it is Kernel 
wide practice.

> Should a caller check against both EOPNOTSUPP *and* ENOTTY?

Current situation is a big mess. All the drivers are returning what 
error codes they wish. You simply cannot trust any error code.

> I searched through linux/drivers/media and found that both values are
> used (EOPNOTSUPP 57 times and ENOTTY 71 times in the version I have in
> use).
> While ENOTTY seems to apply here (at least from its description, not from
> its name)
>
> ENOTTY      "Inappropriate ioctl for device" (originally "Not a
> typewriter")
>
> and I can see why this would be a reason for changing this, EOPNOTSUPP
> doesn't
> really seem to apply, since there is, I assume, no "socket"
> involved here:
>
> EOPNOTSUPP  "Operation not supported on socket"

EOPNOTSUPP is usually used for unsupported I2C messages and that error 
should not be returned to the userspace. As mentioned, situation is 
total mess as there is very different error codes returned for 
unimplemented IOCTLs currently.

> The value I would actually expect to be used in case an operation is
> not supported by a device is
>
> ENOTSUP     "Operation not supported"
>
> Interestingly the driver source uses ENOTSUPP (note the double 'P') 8
> times,
> but that name is not defined according to man errno(3).
>
> So the bottom line is that there appears to be some confusion as to
> which errno
> value to return in case an operation is not supported.
> Maybe all these return values should be set to ENOTSUP (with a single
> 'P' at the end)?
>
> Klaus

Currently, for those old statistic IOCTLs there is two errors documented:
ENOTTY = IOCTL is not supported at all
EAGAIN = fronted is unable to perform IOCTL at the time (eg it is sleeping)

But in real life, drivers are returning very many different error codes 
and you could not trust. Maybe this will be changed slowly to documented 
error codes, during 5 or 10 years or so.

Surely it will not happen anytime soon unless someone has time to start 
looking demod driver by driver and changing error codes.

regards
Antti

-- 
http://palosaari.fi/
