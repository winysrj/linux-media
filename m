Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35254 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab1JRRui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 13:50:38 -0400
Received: by iaek3 with SMTP id k3so1043130iae.19
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2011 10:50:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACGoy5nHCM9CCEa8B-xFqBqiw3LUKCpwsS=wjsGVBUebPx9-ag@mail.gmail.com>
References: <CACGoy5k=vu5Z9Rh6hkiMEKs4p=VN+3ALUbR=LP_hm1XJXTe=pw@mail.gmail.com>
	<CACGoy5=QGEatHtG-GbpQOPKbmb1sE3ML1aOShGkTVkNCB++V8A@mail.gmail.com>
	<CACGoy5nHCM9CCEa8B-xFqBqiw3LUKCpwsS=wjsGVBUebPx9-ag@mail.gmail.com>
Date: Tue, 18 Oct 2011 14:50:36 -0300
Message-ID: <CACGoy5nFqCa7L5aiENgz9Zwxb5cs=u-6v+VBR+OUi22U+LRLTw@mail.gmail.com>
Subject: Re: support for tv tuner tda18211 in Iconbit U100 analog stick
From: Ariel Jolo <ariel.jolo@coso-ad.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bump, could anybody give me a hand on this ?

Thanks !


On Sun, Oct 16, 2011 at 5:02 PM, Ariel Jolo <ariel.jolo@coso-ad.com> wrote:
>
> Hey guys, I'm having the same issue here. I bought a MSI Digi VOX Mini
> II Analog (which was documented as having RTL2832 or AF9016 chips) but
> mine is:
> 1f4d:0237 G-Tek Electronics Group
>
> Here's the syslog output when I plug it in:
> http://pastebin.com/fWc7hM18
>
> As Ling, I can't get a tuner to work nor does /dev/dvb get created.
> I really need some help on this.
> Thank you very much !
>
>
> On 13 Oct 2011, Antti Palosaari wrote:
> > From: Antti Palosaari <crope <at> iki.fi>
> > Subject: Re: support for tv tuner tda18211 in Iconbit U100 analog stick
> > Date: 2011-10-13 13:21:41 GMT (3 days, 6 hours and 26 minutes ago)
> > CX23102 + TDA18211 (== DVB-T only version of TDA18271)>
> >
> >Maybe someone have better knowledge about that as I am not any familiar
> >with CX23102 nor analog TV side.
> >
> >Antti
> >
> >On 10/09/2011 03:56 AM, Ling Sequera wrote:
> >> I try to post this at linux-media <at> vger.kernel.org
> >> <mailto:linux-media <at> vger.kernel.org>, but the system rejects the
> >> sending, Excuse me for send this to you, I have understood that you are
> >> one of the developers of the tda18271 module.
> >>
> >> I have a "Mygica u719c usb analog tv stick", lsusb output identify this
> >> device as: "ID 1f4d:0237 G-Tek Electronics Group". Googling, I found
> >> that this device is the same "Iconbit Analog Stick U100 FM
> >> <http://translate.google.es/translate?sl=ru&tl=en&js=n&prev=_t&hl=es&ie=UTF-8&layout=2&eotf=1&u=http%3A%2F%2Fwww.f1cd.ru%2Ftuners%2Freviews%2Ficonbit_u100_fm_iconbit_u500_fm_page_1%2F>",
> >> which has support in the kernel since version 3.0 as shown here
> >> <http://cateee.net/lkddb/web-lkddb/VIDEO_CX231XX.html>. I opened the
> >> device to corfirm this information, and effectively, it has to chips,
> >> the demod Conexan "CX23102" and the DVB-T tuner NPX "TDA-18211". I
> >> installed the precompiled version of kernel 3.0.4, and the device was
> >> reconized, but only works in the modes: composite and s-video. I check
> >> the source code and I found that it don't support tv tuner mode
> >> (.tuner_type=TUNER_ABSENT in 513 line of the cx231xx-cards.c
> >> <http://lxr.linux.no/#linux+v3.0.4/drivers/media/video/cx231xx/cx231xx-cards.c>
> >> source file), I want to add support for this. The TDA-18211 tuner has
> >> support in the kernel in the module tda18271 according to the thread of
> >> this mailing list
> >> <http://www.mail-archive.com/linux-dvb <at> linuxtv.



--

Ariel Jolo * Redactor
Tel: +54 (11) 3965.6324
Morelos 450 2° Of. B (C1406BQD)
Ciudad de Buenos Aires * Argentina
