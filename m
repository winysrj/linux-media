Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dcharvey@dsl.pipex.com>) id 1JgHKh-0003hq-Co
	for linux-dvb@linuxtv.org; Mon, 31 Mar 2008 12:33:49 +0200
Message-ID: <47F0BDE4.4060205@dsl.pipex.com>
Date: Mon, 31 Mar 2008 03:33:08 -0700
From: David Harvey <dcharvey@dsl.pipex.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <mailman.1.1206957601.1318.linux-dvb@linuxtv.org>
In-Reply-To: <mailman.1.1206957601.1318.linux-dvb@linuxtv.org>
Subject: [linux-dvb] Nova - T disconnects
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

Just a quick update.  I installed hardy (2.6.24) onto my mythbox (epia 
mini itx) for testing and can confirm the same disconnect behaviour with 
the bundled kernel presently, have not yet tried the latest hg-src with 
this config.  The " hub 4-1:1.0: port 2 disabled by hub (EMI?), 
re-enabling..." by which I mean the facility to re-enable helps no end 
in requiring no reboot to reset the dvb device.
I have a usb nova-t and nova-td (the latter of which I haven't tried 
again yet).

Will report back with results of up to date mercurial if there is any 
likelihood of seeing a different result?

Cheers,

dh

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
