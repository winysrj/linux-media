Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp113.rog.mail.re2.yahoo.com ([68.142.225.229]:43378 "HELO
	smtp113.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750877AbZAYSpl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 13:45:41 -0500
Message-ID: <497CB355.3030408@rogers.com>
Date: Sun, 25 Jan 2009 13:45:41 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Tuning a pvrusb2 device.  Every attempt has failed.
References: <20090123015815.GA22113@shibaya.lonestar.org>
In-Reply-To: <20090123015815.GA22113@shibaya.lonestar.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A. F. Cano wrote:
> Still trying to get the OnAir Creator to work.  It is properly recognized
> by the pvrusb2 driver, but I can't seem to get any further.  I'm now
> trying to scan the digital channels.
>   

While you seem to be trying to scan for OTA channels, I would like
confirmation that this is indeed the case of what you are attempting, as
opposed to searching for digital cable channels.

> Can anyone suggest other tools I might have missed?  Explain why I'm getting
> the results above? Since both mythtv and kaffeine find some channels in the
> scan, shouldn't I be able to watch them?  To narrow down the problem, I was
> going to tune the card to one of the channels and then use mplayer to read
> directly from the device, but I can't even change the channel.

If you are mistakenly searching for digital cable channels using the OTA
settings, that would explain a number of the observations you have
described.
