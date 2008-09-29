Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.server.beonex.com ([78.46.195.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux.news@bucksch.org>) id 1KkSPn-0003xu-22
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 01:44:31 +0200
Message-ID: <48E1686E.60207@bucksch.org>
Date: Tue, 30 Sep 2008 01:44:46 +0200
From: Ben Bucksch <linux.news@bucksch.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] [Bug] gnutv -cammenu hangs
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

Hey,

I'd like to update the firmware of my CA module, but gnutv -cammenu does 
nothing, it just sits there without any output.

Environment:
SkyStar HD (STB0899) with CI, using the multiproto drivers.
Ubuntu 8.04.1 with self-compiled linuxtv-dvb-apps from hg tip. Same 
problem on Gentoo.

Reproduction:
1. Starting "gnutv -adapter 1 -cammenu"

Actual results:
Nothing. The command prompt does not return (i.e. gnutv runs), and no 
output comes from gnutv. It just sits there, forever. No error message.

I have no way to resolve the problem, because I have no idea what the 
problem is.

Expected result:
Detailled error message pointing me to the problem, so that I can fix it.

E.g. "Driver does not support this operation", "Could not contact CA 
module - is it inserted?" or "Could not contact smartcard. Check that 
it's inserted in the right direction and side" or whatever. This is the 
minimum level of precision, better (e.g. "CA module did not react to 
command foo") would be good.

Please also report what *did* work, so that I can exclude error causes. 
E.g. "CA initialization succeeded" tells me that the CI adapter and CA 
module is inserted correctly.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
