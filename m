Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cp-out3.libero.it ([212.52.84.103])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ferrarir@libero.it>) id 1L0KgE-00045a-BI
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 19:43:07 +0100
Received: from libero.it (192.168.17.1) by cp-out3.libero.it (8.5.016.1)
	id 49198A570028EE19 for linux-dvb@linuxtv.org;
	Wed, 12 Nov 2008 19:42:32 +0100
Date: Wed, 12 Nov 2008 19:42:32 +0100
Message-Id: <KA8HAW$BA77C8734B235EE8D3752A2B68806340@libero.it>
MIME-Version: 1.0
From: "ferrarir\@libero\.it" <ferrarir@libero.it>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Subject: [linux-dvb] Help with multiproto and myth
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

Hello,
i'm having problem watching dvb-s2 channels using multiproto drivers and mythtv.
i've compiled multiproto drivers and mythtv 0.21 patched with this patch:
http://svn.mythtv.org/trac/raw-attachment/ticket/5403/mythtv_multiproto.5.patch
i'm able to scan dvb-s2 transponders after updating mythconverg.dtv_multiplex table to '8psk' (modulation field) but i'm not able to watch hd channels ...
Mythfrontend complains about "no lock"

Any suggestion?
Thanks

PS: Don't know if this is wrong place for my question. Please let me know where to ask if i'm wrong.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
