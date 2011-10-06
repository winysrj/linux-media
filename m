Return-path: <linux-media-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:39664 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab1JFIfz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 04:35:55 -0400
Message-ID: <4E8D6867.7000807@web.de>
Date: Thu, 06 Oct 2011 10:35:51 +0200
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
References: <201109302358.11233.liplianin@me.by>
In-Reply-To: <201109302358.11233.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 30.09.2011 22:58, Igor M. Liplianin wrote:
> Currently, usb_register calls two times with cloned structures, but for
> different driver names. Let's remove it.

It looks like the comments and the patch under 
http://patchwork.linuxtv.org/patch/8042/ got mixed up.

Regards,
  André
