Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:50464 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab2JQJeN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 05:34:13 -0400
Message-ID: <507E7872.8030300@schinagl.nl>
Date: Wed, 17 Oct 2012 11:20:50 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: AF9035 firmware repository
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey antti, list,

whilst trying to help some Asus U3100+ users with the recent patches I 
ran into an issue. For some strange reason his chip_id was 0xff. I'd 
hope this is somehow supplied by the firmware. I think I had the exact 
same issue until I used Antti's latest firmware for the AF9035.

Having said that, I know antti currently hosts the latest firmware for 
the af9035, but there seem to be several out in the wild and people 
googling for the firmware tend to find the really old one.

I'm pretty certain that Afa-tech, IT-tech etc won't allow the firmware 
to live in the kernel, or simply refuse to answer shuch a plead? They 
could be persuaded by the maintainer to at least have it live in 
http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git or 
if that fails, have it pulled by Documentation/dvb/get_dvb_firmware? 
(Btw, why is it get_dvb_firmware? I didn't find a generic script or 
other devices that did the same).

I'll update the af9035 wikipage to link to antti's firmware for now.

Oliver


