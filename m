Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49188 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab2AVB7x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 20:59:53 -0500
Message-ID: <4F1B6D96.8000807@iki.fi>
Date: Sun, 22 Jan 2012 03:59:50 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Realtek RTL2831U
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

I picked up again my old RTL2831U tree and upgraded to current level. It 
supports only RTL2831U, not RTL2832U or any other. I think I will 
pull-request it to the master in hope it get development effort. I have 
no time for it. It is working, but does not do anything extra - just 
show DVB-T picture. Only NEC remote. No signal statistics. No other USB 
IDs than Realtek reference and 14aa:0160 has my device. New USB IDs 
(patch or mail) are welcome.

Here it is, PULL request is sent next week.
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/realtek


For the newer Realtek devices that same USB-bridge could be used, I 
named it dvb_usb_rtl28xxu. I tested it also using RTL2832U and it 
worked. RTL2832 demod driver I was using is stubbed test version and 
thus I will not release it. Feel free to write RTL2832 demod driver :-)

regards
Antti
-- 
http://palosaari.fi/
