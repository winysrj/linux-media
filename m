Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34417 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3FEBfH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 21:35:07 -0400
Message-ID: <51AE95A1.1090100@iki.fi>
Date: Wed, 05 Jun 2013 04:34:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Petter Selasky <hps@bitfrost.no>
CC: unlisted-recipients:; linux-media@vger.kernel.org,
	Juergen Lock <nox@jelal.kn-bremen.de>
Subject: Re: TT-USB2.0 and high bitrate packet loss (DVB-C/T)
References: <51A70713.6030802@bitfrost.no> <51AB385A.4040701@bitfrost.no> <51ABB2D1.6080908@iki.fi>
In-Reply-To: <51ABB2D1.6080908@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2013 12:02 AM, Antti Palosaari wrote:
> On 06/02/2013 03:19 PM, Hans Petter Selasky wrote:

>> I think I will have to get another USB based receiver with CI slot. Any
>> recommendations for DVB-T ?
>
> There is no many alternatives available. I suspect Anysee E7 serie is
> the only one. And I am not even sure if its CI works anymore. Lastly
> when I tested it I didn't get scrambled channels working - but it could
> be due to card entitlements were not upgraded. Anyhow, if there is bug
> then it should be easy to fix.

I just tested, actually first bisecting back to Kernel 3.3 and VLC2 and 
it didn't work... That makes me suspect it was VLC which has gone 
broken. So I tried gnutv & mplayer and surprise CI was working! Both 
Anysee E7 TC and Anysee E7 T2C. Tested only DVB-C as I don't have DVB-T 
subscription card. CI/CAM worked earlier for VLC somehow too.

Start tuning on terminal:
gnutv -channels /path/to/channels.conf "scrambled channel"
Start mplayer on the another terminal:
mplayer /dev/dvb/adapter0/dvr0

It is a little bit boring situation as there is no very good Gnome 
Desktop TV application. Have never been...

regards
Antti

-- 
http://palosaari.fi/
