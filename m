Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp31.wxs.nl ([195.121.247.33]:54563 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab0BPHea (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 02:34:30 -0500
Received: from localhost (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl
 (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
 with ESMTP id <0KXX00JZYBP7M3@psmtp31.wxs.nl> for linux-media@vger.kernel.org;
 Tue, 16 Feb 2010 08:34:27 +0100 (CET)
Date: Tue, 16 Feb 2010 08:33:49 +0100
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Compro U80
In-reply-to: <160493.426.1266279095486.JavaMail.root@zimbra5>
To: James Troup <james@linuxterminal.com>
Cc: drappa <drappa@iinet.net.au>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <4B7A4A5D.6060201@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <160493.426.1266279095486.JavaMail.root@zimbra5>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Realtek driver (a windows-like driver I got from the manufacturer) 
only supported the mt2060 and mx5005.

I have heard of U80 working.
Please give the new driver (alas with no IR remote support) from
anttip/rtl2831u

If there is a different tuner, that driver is set up so that you can 
incorporate other tuners easily.


James Troup wrote:
> Hi Jan,
> someone in the chat channel has told me that the driver does not support 
> the qt1010 tuner that I have.
> Is this correct?
> 
 > I am using the hg clone on your driver rtl2831-r2
> James


 > Hi Jan,
 >
 > I bought the Compro U80, compiled the driver,
 > but I don't seem to be able to tune. "tuning failed"
 >
 > :~$ scan /usr/share/dvb/dvb-t/au-Adelaide ~/Desktop/channels.conf
 > scanning /usr/share/dvb/dvb-t/au-Adelaide
 > using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
 > initial transponder 226500000 1 3 9 3 1 1 0
 > initial transponder 177500000 1 3 9 3 1 1 0
 > initial transponder 191625000 1 3 9 3 1 1 0
 > initial transponder 219500000 1 3 9 3 1 1 0
 > initial transponder 564500000 1 2 9 3 1 2 0
 >  >>> tune to:
 > 
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
 > WARNING: >>> tuning failed!!!
 >
 > Where is the best place to ask questions for this?
 >
