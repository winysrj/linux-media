Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:53452 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZGRMRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2009 08:17:17 -0400
Received: by ey-out-2122.google.com with SMTP id 9so337867eyd.37
        for <linux-media@vger.kernel.org>; Sat, 18 Jul 2009 05:17:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907181246.44288.mario.fetka@gmail.com>
References: <1245098160.20120.0.camel@asrock>
	 <1247882773.23687.14.camel@miki-desktop>
	 <200907181246.44288.mario.fetka@gmail.com>
Date: Sat, 18 Jul 2009 14:17:15 +0200
Message-ID: <d9def9db0907180517p6aba52cbwf1617a512a0e7ad6@mail.gmail.com>
Subject: Re: [linux-dvb] Terratec Cinergy HTC USB XS HD
From: Markus Rechberger <mrechberger@gmail.com>
To: Mario Fetka <mario.fetka@gmail.com>
Cc: Alain Kalker <miki@dds.nl>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com, linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jul 18, 2009 at 12:46 PM, Mario Fetka<mario.fetka@gmail.com> wrote:
> On Saturday, 18. July 2009 04:06:13 Alain Kalker wrote:
>> Op maandag 15-06-2009 om 22:36 uur [tijdzone +0200], schreef sacha:
>> > Hello
>> >
>> > Does anybody know if this devise will ever work with Linux?
>> > It was promised by one person last year the support will be available
>> > within months. One year has gone, nothing happens.
>> > Is there any alternatives to develop a driver for this devise aside from
>> > this person?
>>
>> Since there has been no answer to your question for some time, I think I
>> will step in.
>>
>> >From http://mcentral.de/wiki/index.php5/Terratec_HTC_XS , the future for
>>
>> a driver from Markus for this device does seem to look quite bleak.
>> However, from looking in the mailinglist archive I gather that Steven
>> Toth has offered to try getting it to work if someone is willing to
>> provide him with a device.
>> Maybe you two could get in contact.
>> I myself am also interested in a driver for this device but I haven't
>> got one yet.
>>
>> Kind regards,
>>
>> Alain
>>
> as far as i know there already exists a driver but it could not be published
> as it is based on the micronas refernce driver
>
> i think the problem is related to
>
> http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030738.html
>
> but this new situation with
> http://www.tridentmicro.com/Product_drx_39xyK.asp
>
> can maby change something about this chip
>
> and it would be possible to get the rights to publish the driver under  gpl-2
>

This won't solve the issue that the AVFB4910 has been discontinued.
This affects FM Radio, Analogue TV, Composite and S-Video, that IC
didn't get bought by Trident.

regards,
Markus
