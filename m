Return-path: <linux-media-owner@vger.kernel.org>
Received: from sirokuusama.dnainternet.net ([83.102.40.133]:39437 "EHLO
	sirokuusama.dnainternet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932175Ab2DQNhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 09:37:55 -0400
Message-ID: <4F8D70A7.4050105@iki.fi>
Date: Tue, 17 Apr 2012 16:31:19 +0300
From: Anssi Hannula <anssi.hannula@iki.fi>
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: Florian Fainelli <f.fainelli@gmail.com>,
	linux-media@vger.kernel.org, marbugge@cisco.com, hverkuil@cisco.com
Subject: Re: [RFC] HDMI-CEC proposal
References: <4F86F3A6.9040305@gmail.com> <4F873CE7.4040401@schinagl.nl>
In-Reply-To: <4F873CE7.4040401@schinagl.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

12.04.2012 23:36, Oliver Schinagl kirjoitti:
> Since a lot of video cards dont' support CEC at all (not even
> connected), don't have hdmi, but work perfectly fine with dvi->hdmi
> adapters, CEC can be implemented in many other ways (think media centers)
> 
> One such exammple is using USB/Arduino
> 
> http://code.google.com/p/cec-arduino/wiki/ElectricalInterface
> 
> Having an AVR with v-usb code and cec code doesn't look all that hard
> nor impossible, so one could simply have a USB plug on one end, and an
> HDMI plug on the other end, utilizing only the CEC pins.
> 
> This would make it more something like LIRC if anything.

There already exists a device like this (USB CEC adapter with hdmi
in/out) with open source userspace driver, developed for the XBMC Media
Center (apparently MythTV is also supported):

http://www.pulse-eight.com/store/products/104-usb-hdmi-cec-adapter.aspx
http://libcec.pulse-eight.com/
https://github.com/Pulse-Eight/libcec

-- 
Anssi Hannula
