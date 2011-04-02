Return-path: <mchehab@pedra>
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:47204 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756426Ab1DBTWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Apr 2011 15:22:22 -0400
Received: by qyk27 with SMTP id 27so3483852qyk.20
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2011 12:22:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D977619.4080607@iki.fi>
References: <BANLkTikXBUFjU-BjHv9LO2eTVn31rvdivQ@mail.gmail.com> <4D977619.4080607@iki.fi>
From: Sami Haahtinen <sami@haahtinen.name>
Date: Sat, 2 Apr 2011 22:22:00 +0300
Message-ID: <BANLkTikfDC=2Cdh+eSfXB-p=fEXCtvDCBQ@mail.gmail.com>
Subject: Re: Anysee E30 Combo Plus failing to tune
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hey,

On Sat, Apr 2, 2011 at 22:16, Antti Palosaari <crope@iki.fi> wrote:
> On 04/02/2011 09:52 PM, Sami Haahtinen wrote:
>> I have a Anysee E30 Combo Plus and i'm having trouble getting it to
>> detect properly. According to various sources it should be supported,
>> but yet it fails for me. I've tried with the stock driver and the
>> backports one (one instructed in wiki) and neither work.
> I think your device is newer model where is new DNOD44CDV086A tuner module
> and inside that module is TDA18212 silicon tuner which does not have working
> driver yet. If your device have antenna loop-through it does have this new
> tuner module.

Yup, it has a loop through. So it is most likely a newer model.

> Unfortunately I don't have this device model, I got older one :-(. But
> luckily enough I have got E7TC which is almost similar as E30 Combo. I have
> DVB-C and DVB-T picture out from E7TC, it is just up to few weeks I will get
> TDA18212 tuner driver ready.

If you need one of these buggers for development use, I can arrange that..

Regards,
-- 
Sami Haahtinen
Bad Wolf Oy
+358443302775
