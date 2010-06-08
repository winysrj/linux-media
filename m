Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f204.google.com ([209.85.211.204]:57779 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab0FHJVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 05:21:22 -0400
Received: by ywh42 with SMTP id 42so3715798ywh.15
        for <linux-media@vger.kernel.org>; Tue, 08 Jun 2010 02:21:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <291a60d4cc2cd21b923d74bd86856c6b.squirrel@www.vanbest.eu>
References: <20100607070123.GA28216@wozi.local>
	<4C0D4E18.30507@vanbest.org>
	<20100608062621.GA4053@wozi.local>
	<291a60d4cc2cd21b923d74bd86856c6b.squirrel@www.vanbest.eu>
Date: Tue, 8 Jun 2010 10:59:11 +0200
Message-ID: <AANLkTik0KfaObIY7Hwki-_uuIU6m3KgsaaiNa5u4WnSu@mail.gmail.com>
Subject: Re: Is anybody working on TechniSat CableStar Combo HD CI USB device?
From: Markus Rechberger <mrechberger@gmail.com>
To: Jan-Pascal van Best <janpascal@vanbest.org>
Cc: Tobias Maier <tobias@pfadfinder-kirchzarten.de>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 8, 2010 at 10:03 AM, Jan-Pascal van Best
<janpascal@vanbest.org> wrote:
> On Tue, June 8, 2010 08:26, Tobias Maier wrote:
>>> The Micronas DRX series seems to 'evil' in that there
>>> is only a closed-source driver and the manufacturer doesn't cooperate
>>> with open source developers.
>> Have you asked them or are you simply asuming this because there is no
>> open source driver?
> "
> It is important to notice that the vendor (Trident) doesn't seem to want
> helping with open source development. Contacts with the vendor were tried
> during 2007 and 2008 in order to get their help by opening docs, via Linux
> Foundation NDA program, without success.
>
> The vendor also seems to be refusing so far to help the development of a
> driver for their demod DRX-K line that they acquired from Micronas (as
> pointed at http://linux.terratec.de/tv_en.html).
> "
> (http://www.linuxtv.org/wiki/index.php/Trident_TM6000)
>
>

We have been working on getting those chipsets work with our devices.
http://sundtek.com/shop/Digital-TV-Sticks/Sundtek-MediaTV-Digital-Home-DVB-CT.html

Trident is also still improving the quality of their driver and
firmware, it very much makes
sense that they handle their driver especially since those DRX drivers
are very complex
(basically too complex for being handled by the community, the drivers
would just
end up somewhere unmaintained).

Best Regards,
Markus
