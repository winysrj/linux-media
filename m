Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34773 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab1H1Xaa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 19:30:30 -0400
Message-ID: <4E5ACF92.3020907@iki.fi>
Date: Mon, 29 Aug 2011 02:30:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: usb_set_intfdata usage for two subdrivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to implement DVB USB device smartcard reader support using 
USB-serial. The main problem is now that both DVB-USB and USB-serial 
uses interface data (usb_set_intfdata / usb_get_intfdata) for state.

Is there any common solution to resolve issue easily?

regards
Antti

-- 
http://palosaari.fi/
