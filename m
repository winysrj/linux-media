Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KDxIT-0002Ms-8p
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 10:02:38 +0200
Message-ID: <486B3617.3070702@iki.fi>
Date: Wed, 02 Jul 2008 11:02:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair M <tlli@hotmail.com>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
In-Reply-To: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
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

Alistair M wrote:
> I finally got the usb Leadtek DTV dongle gold tuner working using the 
> below method. The tuner works fine with kaffeine and mythtv, but no luck 
> with the remote (Y04G0044).

I can add support for remote if you can take some usb-sniffs. Start 
sniffer and plug stick. Windows driver loads remote keymaps when stick 
is plugged, no need to tune.
http://benoit.papillault.free.fr/usbsnoop/

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
