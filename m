Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:50516 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756728Ab1JCR4N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 13:56:13 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Antti Palosaari <crope@iki.fi>
Cc: =?utf-8?Q?Istv=C3=A1n_V=C3=A1radi?= <ivaradi@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com>
	<4E485F81.9020700@iki.fi> <4E48FF99.7030006@iki.fi>
	<4E4C2784.2020003@iki.fi>
	<CAFk-VPzKa4bNLCMMCagFi1LLK6PnY245YJqP5yisQH77nJ0Org@mail.gmail.com>
	<4E5BA751.6090709@iki.fi>
	<CAFk-VPypTuaKgAHPxyvKg7GHYM358rZ2kypabfvxG-x7GjmFpw@mail.gmail.com>
	<4E5BAF03.503@iki.fi> <87wrdri4sp.fsf@nemi.mork.no>
	<4E60DB09.1060304@iki.fi> <4E832FE6.7020103@iki.fi>
	<4E85E1FA.7020709@iki.fi>
Date: Mon, 03 Oct 2011 19:56:07 +0200
In-Reply-To: <4E85E1FA.7020709@iki.fi> (Antti Palosaari's message of "Fri, 30
	Sep 2011 18:36:26 +0300")
Message-ID: <87zkhix8lk.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti Palosaari <crope@iki.fi> writes:

> If you would like to help me then you can find out correct device name
> and whats needed for that. I mainly see following possibilities;
> * /dev/ttyAnyseeN
> * /dev/ttyDVBN
> * /dev/adapterN/serial

You should probably include the TTY maintainer in that discussion.  I
assume this device won't really be a TTY device?  Then it probably
shouldn't be named like one.


Bjørn
