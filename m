Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33099 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1HQUll (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 16:41:41 -0400
Message-ID: <4E4C2784.2020003@iki.fi>
Date: Wed, 17 Aug 2011 23:41:40 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Smart card reader support for Anysee DVB devices
References: <CAFk-VPxQvGiEUdd+X4jjUqcygPO-JsT0gTFvrX-q4cGAW6tq_Q@mail.gmail.com> <4E485F81.9020700@iki.fi> <4E48FF99.7030006@iki.fi>
In-Reply-To: <4E48FF99.7030006@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2011 02:14 PM, Antti Palosaari wrote:
> On 08/15/2011 02:51 AM, Antti Palosaari wrote:
>> Biggest problem I see whole thing is poor application support. OpenCT is
>> rather legacy but there is no good alternative. All this kind of serial
>> drivers seems to be OpenCT currently.
> 
> I wonder if it is possible to make virtual CCID device since CCID seems
> to be unfortunately the only interface SmartCard guys currently care.

I studied scenario and looks like it is possible to implement way like,
register virtual USB HCI (virtual motherboard USB controller) then
register virtual PC/SC device to that which hooks all calls to HW via
Anysee driver. Some glue surely needed for emulate PC/SC. I think there
is not any such driver yet. Anyhow, there is virtual USB HCI driver
currently in staging which can be used as example, or even use it to
register virtual device. That kind of functionality surely needs more
talking...


regards,
Antti
-- 
http://palosaari.fi/
