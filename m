Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48C02A45.3000108@gmail.com>
Date: Thu, 04 Sep 2008 22:34:45 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,  v4l-dvb-maintainer@linuxtv.org,
	akpm@linux-foundation.org
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] DVB Update [PATCH 0/31] multiproto tree
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

This patchset adds newer delivery systems, modulations and parameters.

It adds a much needed uplift for DVB for adding newer delivery systems
such as DVB-S2, DVB-H. Also it allows the addition of future modulations
in an easier manner. Newer delivery systems such as DMB-T/H and ISDB-T/H
can easily be added later on, without breaking compatibility.

The initial post for the update:
http://article.gmane.org/gmane.linux.drivers.dvb/25606

More details are available according to the discussions:
http://article.gmane.org/gmane.linux.drivers.dvb/25608
http://article.gmane.org/gmane.linux.drivers.dvb/25610
http://article.gmane.org/gmane.linux.drivers.dvb/25611

which were reworked again according to
Code Review from Johannes Stezenbach <js@linuxtv.org>. (The rework
happened just immediate after a pull request and a merge):

http://article.gmane.org/gmane.linux.drivers.dvb/25616

It was reworked again,
Code Review from Oliver Endriss <o.endriss@gmx.de>,
reviewed again and relevant changes applied:

http://article.gmane.org/gmane.linux.drivers.dvb/37406

The resulting changes were also tested. Drivers also available at
http://jusst.de/hg/multiproto
Some newer drivers also on the way.


The DVB API update patches are available also at:
http://www.kernel.org/pub/linux/kernel/people/manu/dvb_patches/

Sample applications:
simple zapping app
http://linuxtv.org/hg/dvb-apps/file/ef0bf9bd3bd4/test/szap2.c

VDR 1.7.0 ftp://ftp.cadsoft.de/vdr/Developer/vdr-1.7.0.tar.bz2

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
