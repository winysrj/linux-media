Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ianm_97@fastmail.fm>) id 1KIdcO-0001Yb-UE
	for linux-dvb@linuxtv.org; Tue, 15 Jul 2008 08:02:35 +0200
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id ACAC013980B
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 02:02:28 -0400 (EDT)
Received: from [192.168.1.101] (123-243-199-51.static.tpgi.com.au
	[123.243.199.51])
	by mail.messagingengine.com (Postfix) with ESMTPA id C9366F506
	for <linux-dvb@linuxtv.org>; Tue, 15 Jul 2008 02:02:27 -0400 (EDT)
Message-ID: <487C3D71.1000409@fastmail.fm>
Date: Tue, 15 Jul 2008 16:02:25 +1000
From: Ian MacKinnell <ianm_97@fastmail.fm>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvbscan initial file DVB-T Australia/Sydney
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

Hi

Using the file au-Sydney_North_Shore that comes with dvb_utils in
Debian/Ubuntu 
(/usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Sydney_North_Shore),
the scan utility does not find any of the Seven-Network channels,
although it finds all the other digital TV and radio channels in Sydney.

After some experimenting with the scan utility, I changed the file
/usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Sydney_North_Shore as
follows:

# Seven VHF6
-T 177500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
+T 177500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE

and scan now identifies all the Channel Seven network stations
perfectly, as well as all the other Sydney channels found earlier.

Please change the Channel Seven entry in the au-Sydney_North_Shore file
accordingly and also can you remove the redundant au-sydney_north_shore
file - it is an older, obsolete version.

NB: all the other VHF TV channels in Sydney have 3/4 as the 4th field -
I simply changed Channel Seven to be the same as them, and that worked.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
