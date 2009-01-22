Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from proxy1.bredband.net ([195.54.101.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <henke@kurelid.se>) id 1LQ82H-0001XH-FW
	for linux-dvb@linuxtv.org; Thu, 22 Jan 2009 23:28:31 +0100
Received: from ironport2.bredband.com (195.54.101.122) by proxy1.bredband.net
	(7.3.127) id 494BF21C00A630E5 for linux-dvb@linuxtv.org;
	Thu, 22 Jan 2009 23:28:24 +0100
Received: from evermeet.kurelid.se (localhost.localdomain [127.0.0.1])
	by evermeet.kurelid.se (8.14.2/8.13.8) with ESMTP id n0MMSNKZ025288
	for <linux-dvb@linuxtv.org>; Thu, 22 Jan 2009 23:28:23 +0100
Message-ID: <3ea852b9acf2cfadc88827c48a099eb4.squirrel@mail.kurelid.se>
Date: Thu, 22 Jan 2009 23:28:22 +0100 (CET)
From: "Henrik Kurelid" <henke@kurelid.se>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: [linux-dvb] High Level CI and MMI
Reply-To: linux-media@vger.kernel.org
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

Hi all,

I am currently implementing CA support for the FireDTV/FloppyDTV cards. This driver follows the high level API as described in
Documentation/dvb/ci.txt. Most parts are now implemented and working fairly well. There are however a number of issues that I am currently wrestling
with. Mostly regarding usage that I feel could do with some clarification in the documentation.

The issues are regarding CA_SEND/GET_MSG and e.g. MMI.
When retrieving an APDU from the driver, the CA_GET_MSG ioctl is used. This seems to be used somewhat differently by different applications (e.g.
mythtv, dst_test, kaffeine). Some applications set the tag of the message in order to (I guess) tell the driver what message it wants to receive.
Since this is not done by all applications, I guess the driver can not rely on this. Hence the SEND and GET messages need to be used a
request-response fashion. E.g.
CA_SEND_MSG(CA_INFO_ENQ)
CA_GET_MSG(CA_INFO)
CA_SEND_MSG(APP_INFO_ENQ)
CA_GET_MSG(APP_INFO)

This is all well for CA_INFO, APP_INFO and others. However, when it comes to MMI this is not possible for all cases. In the menu case, we still have
a request-response procedure, e.g.
CA_SEND_MSG(ENTER_MENU)
CA_GET_MSG(MENU_MORE)
CA_GET_MSG(MENU_LAST)
CA_SEND_MSG(MENU_ANSW)
CA_GET_MSG(MMI_CLOSE)

Other MMI situations (many related to where TEST_MORE/LAST is used), may be initiated from the driver instead of the application. In those cases I
don't see how the application should know that the driver has APU(s) ready for retrieval.

How is this meant to be supported? Or is it not? Am I missing something in my reasoning or perhaps this is documented somewhere else?

If someone could help me with some input I would gladly appreciate it

Regards,
Henrik Kurelid

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
