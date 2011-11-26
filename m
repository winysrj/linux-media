Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52096 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab1KZXKu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 18:10:50 -0500
Message-ID: <4ed171f8.e312b40a.54fa.ffffcbc1@mx.google.com>
Subject: Re: PROBLEM: EHCI disconnects DVB & HDD
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Johann Klammer <klammerr@aon.at>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Date: Sat, 26 Nov 2011 23:10:42 +0000
In-Reply-To: <4ECEFBA3.7010808@aon.at>
References: <4ECEFBA3.7010808@aon.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2011-11-25 at 03:21 +0100, Johann Klammer wrote:
> When using a DVB-T Dongle and an external HDD simultaneously, EHCI 
> almost always disconnects.
> 

Ideally HDD, and DVB devices shouldn't share the the same controller. 

Most systems have two.

However, it is difficult for users know how these are assigned as
sockets on a motherboard, or whether just one is available externally.

With respect to af9015 devices it is are not alone, were messages are
lost by operations of other devices.

On the patchwork server is a patch for bus repeating on af9015 usb
bridge TIMEOUT or BUSY errors.

http://patchwork.linuxtv.org/patch/8406/


