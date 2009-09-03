Return-path: <linux-media-owner@vger.kernel.org>
Received: from Siano-NV.ser.netvision.net.il ([199.203.99.233]:18447 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbZICMYN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 08:24:13 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [DVB] Siano: Request help for some unkown SMS message header ID and format
Date: Thu, 3 Sep 2009 15:10:25 +0300
Message-ID: <3E442BA883529143B4AB72530285FC5D02075EE5@s-mail.siano-ms.ent>
In-Reply-To: <1251944381.5100.9.camel@shinel>
From: "Yaron Magber" <yaronm@siano-ms.com>
To: "Shine Liu" <liuxian@redflag-linux.com>
Cc: <linux-media@vger.kernel.org>, "Udi Atar" <udia@siano-ms.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shine,

In general, Uri does not work for Siano anymore, so Linux related issues
can be directed to Udi (CC).

For the issue you raise below:
Operating SMS1180 CMMB requires a user mode host stack, on top of the
driver. CMMB has a proprietary data format, proprietary control table
etc. It is not based on MPEG2 transport steam live DVB-T or ISDB-T.

Regards,
Yaron

-----Original Message-----
From: Shine Liu [mailto:liuxian@redflag-linux.com] 
Sent: Thursday, September 03, 2009 5:20 AM
To: Uri Shkolnik
Cc: linux-media@vger.kernel.org
Subject: [DVB] Siano: Request help for some unkown SMS message header ID
and format

Hi Uri,

I have a Siano USB MDTV Dongle which use the SMS1182(maybe SMS1180)
chipset for CMMB. I was about to write drive for it under Linux, but I
found some SMS messages I can't recognise: SMS messages with header
0x026a, 0x026b, 0x026f, 0x028d, 0x028e, 0x0300 and 0x0301. These
messages should be for CMMB. I want to know the messages format and what
these header ID mean but I can't find these definations in current siano
source code. Could you give me some help on this?

Best regards,

Shine




