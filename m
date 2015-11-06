Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:54177 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbbKFXX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Nov 2015 18:23:59 -0500
Subject: Re: [PATCH] rtl28xxu: fix control message flaws
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
References: <1444495530-1674-1-git-send-email-crope@iki.fi>
From: Benjamin Larsson <benjamin@southpole.se>
Message-ID: <563D3485.7010309@southpole.se>
Date: Sat, 7 Nov 2015 00:15:17 +0100
MIME-Version: 1.0
In-Reply-To: <1444495530-1674-1-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/10/2015 06:45 PM, Antti Palosaari wrote:
> Add lock to prevent concurrent access for control message as control
> message function uses shared buffer. Without the lock there may be
> remote control polling which messes the buffer causing IO errors.
> Increase buffer size and add check for maximum supported message
> length.
>

This patch made at least one of my devices work. Before my log was full 
of errors.

Totally unrelated I do get a fail on loading the firmware. Just retrying 
made it work eventually.

[  143.286498] mn88473 19-0018: downloading firmware from file 
'dvb-demod-mn88473-01.fw'
[  143.551497] mn88473 19-0018: firmware download failed=-32
[  143.826792] rtl2832 19-0010: i2c reg read failed -32
[  143.903215] mn88473 19-0018: downloading firmware from file 
'dvb-demod-mn88473-01.fw'
[  144.345554] mn88473 19-0018: firmware download failed=-32
[  331.060613] mn88473 19-0018: downloading firmware from file 
'dvb-demod-mn88473-01.fw'
[  331.477234] mn88473 19-0018: firmware download failed=-32
[  354.997771] rtl2832 19-0010: i2c reg read failed -32
[  358.591754] mn88473 19-0018: downloading firmware from file 
'dvb-demod-mn88473-01.fw'
[  359.115582] mn88473 19-0018: firmware parity check succeeded=0x20

MvH
Benjamin Larsson
