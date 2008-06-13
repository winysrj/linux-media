Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1K7GcU-0005B4-2M
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 23:15:50 +0200
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1K7Gbu-0005lE-Qw
	for linux-dvb@linuxtv.org; Fri, 13 Jun 2008 21:15:02 +0000
Received: from 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	([77.103.126.124]) by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 21:15:02 +0000
Received: from mariofutire by 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	with local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 13 Jun 2008 21:15:02 +0000
To: linux-dvb@linuxtv.org
From: Andrea <mariofutire@googlemail.com>
Date: Fri, 13 Jun 2008 22:07:44 +0100
Message-ID: <g2unka$ivi$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] How to use a DVB FRONTEND in read only?
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

Hi,

I have a question about multiple access to the dvb framework.

I would like to open the dvb in readonly and take whatever frequency is currently tuned:

1) I open the frontend in read only
2) query the current frequency to check is there is a lock
3) I open the demux, set some filters and read from the demux.

There is a *big* issue here:

The card streams packets *only* and *as long* as the frontend is opened in read/write (by some other 
application) and tuned.
If my application opens the frontend in readonly and there is no other application running, the 
ioctl FE_GET_INFO still returns FE_HAS_LOCK but no data goes through the demux.
As soon as the frontend is tuned, the data arrives.

Am I correct? How can I detect if the dvb is running or not?

Andrea


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
