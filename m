Return-path: <linux-media-owner@vger.kernel.org>
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:53852 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829AbZDEL0Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 07:26:24 -0400
Message-ID: <49D8955C.8030806@gmail.com>
Date: Sun, 05 Apr 2009 13:26:20 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: Possibility of changing the current pixelformat on the
 fly
References: <49D7C17B.80708@gmail.com> <49D87524.9050309@hhs.nl>
In-Reply-To: <49D87524.9050309@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Hans de Goede wrote:
> On 04/04/2009 10:22 PM, Erik Andrén wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> Hi,
>>
>> While trying to get hflip and vflip working for the stv06xx webcam
>> bridge coupled to the vv6410 sensor I've come across the following
>> problem.
>>
>> When flipping the image horizontally, vertically or both, the sensor
>> pixel ordering changes. In the m5602 driver I was able to compensate
>> for this in the bridge code. In the stv06xx I don't have this
>> option. One way of solving this problem is by changing the
>> pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
>> format. When a vertical flip is required, change the format to
>> V4L2_SBGGR8.
>>
>> My current understanding of libv4l is that it probes the pixelformat
>>    upon device open. In order for this to work we would need either
>> poll the current pixelformat regularly or implement some kind of
>> notification mechanism upon a flipping request.
>>
>> What do you think is this the right way to go or is there another
>> alternative.
>>
> 
> The changing of the pixelformat only happens when you flip the data
> before conversion. If you look at the current upside down handling
> code you will see it does the rotate 180 degrees after conversion.
> 
> This is how the vflip / hflip should be handled too. We only have
> 4 (2 really since we don't care about r versus b / u versus v while
> flippiing) destination formats for which we then need to write flipping
> code. Otherwise we need to write flipping code for *all* supported input
> formats, not to mention flipping some input formats is close to impossible
> (JPEG for example).
> 

So you mean we should do the vflip/hflip in software, just exposing
one native format?

Best regards,
Erik

> Regards,
> 
> Hans

> 
> p.s.
> 
> One problem with this approach is that if an apps ask for a native
> cam format which is not one which we can also convert to, the
> flipping won't work. I think this is best solved by simply not
> listing the native formats in the enum-fmt output when the cam
> needs flipping.
> 
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknYlVoACgkQN7qBt+4UG0FwqACfQtawSmcm8rtFUCGZtV9pzVd+
jmkAoKHkibnapkZkDfl4pXd8pjaJ9M0E
=odkv
-----END PGP SIGNATURE-----
