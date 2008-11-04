Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jeisom@gmail.com>) id 1KxDMf-0004Py-Nf
	for linux-dvb@linuxtv.org; Tue, 04 Nov 2008 05:18:03 +0100
Received: by yw-out-2324.google.com with SMTP id 3so1082036ywj.41
	for <linux-dvb@linuxtv.org>; Mon, 03 Nov 2008 20:17:57 -0800 (PST)
Message-ID: <1767e6740811032017x63c1f635u34db2e6e919c2ce7@mail.gmail.com>
Date: Mon, 3 Nov 2008 22:17:57 -0600
From: "Jonathan Isom" <jeisom@gmail.com>
To: "Linux DVB" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] bug with kworld atsc 110/115
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

Hi all
    I have been using dvbstreamer(not to be confused with dvbstream)
and at svn revision r520
of dvbstreamer Adam the author introduced a change in it that causes
my system to hardlock.
The change was if the frontend lost signal lock to Stop all filters
and to start them back up when
signal locked.  Simply by switching transponders I can hard lock the
system in about 1 minute..
Reproducable with kworld atsc 110 and 115(not surprising).  nothing is logged.

Thanks

Jonathan

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
