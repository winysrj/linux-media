Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46488 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbZILPPa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 11:15:30 -0400
Message-ID: <4AABBB0E.10305@iki.fi>
Date: Sat, 12 Sep 2009 18:15:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, matt@pcmus.com
Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote y04g0051 issues
References: <003901ca32fd$259ad820$70d08860$@com>
In-Reply-To: <003901ca32fd$259ad820$70d08860$@com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2009 07:30 PM, Matthew Skinner, PC Mus wrote:
> I have the Leadtek WinFast DTV Dongle Gold which uses the af9015 chip and
> the y04g0051 remote, after a lot of reading I now have the remote partially
> working as only half of the keys are sending codes to "irw"
>
> I read this thread and noticed that the exact keys which work are the ones
> listed with reported codes.
>
>
>
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027058.html
>
>
>
> The keys not mentioned in that thread are the ones not working, so I guess
> the extra codes need to be reported to someone to be added into a new build?
>
>
>
> Can I help in providing these codes and some testing.

You could send missing button codes to me and I will add those to the 
driver. There is debug switch which shows remote events, it is debug=2.

remove driver from memory
# rmmod dvb-usb-af9015

# load driver with needed debug
modprobe dvb-usb-af9015 debug=2

# look codes from log
tail -f /var/log/messages

I am not sure if debugs are enabled with your system build, but if not 
you will need to install and compile current v4l-dvb master.

Antti
-- 
http://palosaari.fi/
