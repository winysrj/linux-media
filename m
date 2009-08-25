Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41889 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbZHYWJp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 18:09:45 -0400
Message-ID: <4A94612A.2070705@iki.fi>
Date: Wed, 26 Aug 2009 01:09:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Subject: Re: Noisy video with Avermedia AVerTV Digi Volar X HD (AF9015) and
 	mythbuntu 9.04
References: <8527bc070908040016x5d5ad15bk8c2ef6e99678f9e9@mail.gmail.com>	 <200908041312.52878.jareguero@telefonica.net>	 <8527bc070908041423p439f2d35y2e31014a10433c80@mail.gmail.com>	 <200908042348.58148.jareguero@telefonica.net>	 <4A945CA4.6010402@iki.fi> <829197380908251501l7731536bg79dd8595cd7ce50d@mail.gmail.com>
In-Reply-To: <829197380908251501l7731536bg79dd8595cd7ce50d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/26/2009 01:01 AM, Devin Heitmueller wrote:
> On Tue, Aug 25, 2009 at 5:50 PM, Antti Palosaari<crope@iki.fi>  wrote:
>> USB2.0 BULK stream .buffersize is currently 512 and your patch increases it
>> to the 65424. I don't know how this value should be determined. I have set
>> it as small as it is working and usually it is 512 used almost every driver.
>> 511 will not work (if not USB1.1 configured to the endpoints).
>>
>> ****
>>
>> Could someone point out how correct BULK buffersize should be determined? I
>> have thought that many many times...
>
> Usually I do a sniffusb capture of the Windows driver and use whatever
> they are using.

Should try that if better trick is not known.

>> ****
>>
>> Also one other question; if demod is powered off and some IOCTL is coming -
>> like FE_GET_FRONTEND - how that should be handled? v4l-dvb -framework does
>> not look whether or not demod is sleeping and forwards that query to the
>> demod which cannot answer it.
>
> In other demods, whenever the set_frontend call comes in the driver
> check to see if the device is asleep and wakes it up on demand.  On
> some demods, you can query a register to get the power state.  In
> other cases you have to manually keep track of whether you previously
> put the demod to sleep using the demod's state structure.

If demod (and tuner) is powered off by bridge (.power_ctrl) that's not 
possible. Is there way to call bridge .power_ctrl to wake up demod and 
tuner? I added param for demdod state to track sleep/wake state and 
return 0 in sleep case. But that does not sounds good solution...

Thank you for fast answer.

regards
Antti
-- 
http://palosaari.fi/
