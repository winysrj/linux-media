Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1L0eAi-0003Vk-2k
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 16:31:54 +0100
Message-ID: <491C4863.1030601@iki.fi>
Date: Thu, 13 Nov 2008 17:31:47 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alain Kalker <miki@dds.nl>
References: <a40e5bb20a32b537a391.1226449195@miki-debian.ensch1.ov.home.nl>
In-Reply-To: <a40e5bb20a32b537a391.1226449195@miki-debian.ensch1.ov.home.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add support for the Digittrade DVB-T USB
 Stick	remote
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Alain Kalker wrote:
> From: Alain Kalker <miki@dds.nl>
> 
> Add support for the Digittrade DVB-T USB Stick remote.
> As the Digittrade USB stick identifies itself as a generic AF9015 USB
> device, the remote cannot be autodetected. To enable it, add the following
> to /etc/modprobe.d/dvb-usb-af9015 or /etc/modprobe.conf:
> 
> options dvb-usb-af9015 remote=4

Could you lower case hex numbers used in ir-table and re-send patch 
please? I think lower case is some rule of Linux Kernel.

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
