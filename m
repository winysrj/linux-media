Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53249 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab0AVPLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 10:11:32 -0500
Message-ID: <4B59C01E.90804@gmail.com>
Date: Fri, 22 Jan 2010 16:11:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, add IR support for digivox
 mini II
References: <1263412807-23350-1-git-send-email-jslaby@suse.cz> <4B4F6BE5.2040102@iki.fi>
In-Reply-To: <4B4F6BE5.2040102@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/14/2010 08:09 PM, Antti Palosaari wrote:
> Device ID 15a4:9016 is reference design ID and it is used by vary many
> devices. Also manufacturer string "Afatech" is chipset default one. This
> leads MSI remote in question configured for many devices using default /
> reference values which I don't like good idea. Strings and other USB
> settings are stored to the device eeprom.

What do you think about the following patches?

thanks,
-- 
js
