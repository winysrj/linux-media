Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:50618 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab1JCMgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 08:36:04 -0400
Message-ID: <4E89AC32.7090708@web.de>
Date: Mon, 03 Oct 2011 14:36:02 +0200
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: Mauro Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
	Michael Schimek <mschimek@gmx.at>,
	Hans Petter Selasky <hselasky@c2i.net>,
	Doychin Dokov <root@net1.cc>,
	Steffen Barszus <steffenbpunkt@googlemail.com>,
	Dominik Kuhlen <dkuhlen@gmx.net>
Subject: Re: [PATCH] pctv452e: hm.. tidy bogus code up
References: <201109302358.11233.liplianin@me.by> <4E89AAD7.2040400@web.de>
In-Reply-To: <4E89AAD7.2040400@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.10.2011 14:30, André Weidemann wrote:
> Hi Igor,
>
> On 30.09.2011 22:58, Igor M. Liplianin wrote:
>> Currently, usb_register calls two times with cloned structures, but for
>> different driver names. Let's remove it.
>>
>> Signed-off-by: Igor M. Liplianin<liplianin@me.by>
>
> Well spotted... The cloned struct should have been removed a long time
> go. The final version of patch I submitted for the tt-connect S2-3600,
> did not contain it anymore:
> http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024233.html
>
> Acked-by: André Weideamm<Andre.Weidemann@web.de>

This should read:
Acked-by: André Weidemann<Andre.Weidemann@web.de>

;-)

Regards
  André
