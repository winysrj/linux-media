Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out5.smtp.messagingengine.com ([66.111.4.29])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <heldal@eml.cc>) id 1Ky2JY-0008DR-R2
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 11:42:14 +0100
From: Per Heldal <heldal@eml.cc>
To: Jelle De Loecker <skerit@kipdola.com>
In-Reply-To: <4912BA94.8060809@kipdola.com>
References: <BF8F0D96-3ED8-4D3D-8EF7-899FCAC4514E@pobox.com>
	<4912BA94.8060809@kipdola.com>
Date: Thu, 06 Nov 2008 11:41:59 +0100
Message-Id: <1225968119.5453.43.camel@ip6-localhost>
Mime-Version: 1.0
Cc: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] dvbloopback:
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

On Thu, 2008-11-06 at 10:36 +0100, Jelle De Loecker wrote:
> In my case it must be an S2API thing, because when I was using 
> Multiproto everything worked fine.
> 
> Or maybe it's a regression in the latest revision (r53?) I should find 
> out ...

dvbloopback copies a number of functions from the dvb source which
aren't exported through the API of which some may have been altered, nor
is it afics prepared to carry the additional tuning attributes. It is
thus a fair assumption that it may need a bit of attention to fully
support tuning via DVB-API v5.

//per




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
