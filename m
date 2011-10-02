Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36058 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1JBVGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Oct 2011 17:06:09 -0400
Received: by vcbfk10 with SMTP id fk10so2297264vcb.19
        for <linux-media@vger.kernel.org>; Sun, 02 Oct 2011 14:06:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E85E1FA.7020709@iki.fi>
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>
	<4E485F81.9020700@iki.fi>
	<4E48FF99.7030006@iki.fi>
	<4E4C2784.2020003@iki.fi>
	<CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>
	<4E5BA751.6090709@iki.fi>
	<CAFk-VPypTuaKgAHPxyvKg7GHYM358rZ2kypabfvxG-x7GjmFpw@mail.gmail.com>
	<4E5BAF03.503@iki.fi>
	<87wrdri4sp.fsf@nemi.mork.no>
	<4E60DB09.1060304@iki.fi>
	<4E832FE6.7020103@iki.fi>
	<4E85E1FA.7020709@iki.fi>
Date: Sun, 2 Oct 2011 23:06:08 +0200
Message-ID: <CAJbz7-1we9e0CpHq0Vb8udkXMXzogk2bK0k2pVmjYH=sP_fKag@mail.gmail.com>
Subject: Re: Smart card reader support for Anysee DVB devices
From: HoP <jpetrous@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	=?ISO-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If you would like to help me then you can find out correct device name and
> whats needed for that. I mainly see following possibilities;
> * /dev/ttyAnyseeN
> * /dev/ttyDVBN
> * /dev/adapterN/serial
>

/dev/ttyscXN

or

/dev/dvb/adapterX/scN

where X = ordered adapter number
and N = ordered smartcard number in one device

/Honza
