Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53637 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971AbZDILOj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2009 07:14:39 -0400
Message-ID: <49DDD897.4000409@iki.fi>
Date: Thu, 09 Apr 2009 14:14:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, chrisneilbrown@gmail.com
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] AVerTV Volar DVB-T USB GPS 805
References: <91591f560904090409x15481f87ra1d7211ec35bc569@mail.gmail.com>
In-Reply-To: <91591f560904090409x15481f87ra1d7211ec35bc569@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chris Brown wrote:
> Hello
> 
> This device doesnt seem to work
> I've tried several different modules referenced in the dvb-t usb page on 
> linuxtv
> Any ideas?
> 
> Bus 001 Device 003: ID 07ca:a805 AVerMedia Technologies, Inc.
> Bus 001 Device 004: ID 0471:082d Philips
> Bus 001 Device 002: ID 0409:005a NEC Corp. HighSpeed Hub

What does lsusb -vv -d 07ca:a805 says?

Antti
-- 
http://palosaari.fi/
