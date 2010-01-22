Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <koos@kzdoos.xs4all.nl>) id 1NYHVg-0005dr-KN
	for linux-dvb@linuxtv.org; Fri, 22 Jan 2010 12:17:06 +0100
Received: from koos.idefix.net ([82.95.196.202] helo=kzdoos.xs4all.nl)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1NYHVg-00023J-41; Fri, 22 Jan 2010 12:17:04 +0100
Received: from kzdoos.xs4all.nl (localhost [127.0.0.1])
	by kzdoos.xs4all.nl (8.14.2/8.14.2/Debian-2build1) with ESMTP id
	o0MBGujO017515
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-dvb@linuxtv.org>; Fri, 22 Jan 2010 12:16:56 +0100
Received: (from koos@localhost)
	by kzdoos.xs4all.nl (8.14.2/8.14.2/Submit) id o0MBGul9017514
	for linux-dvb@linuxtv.org; Fri, 22 Jan 2010 12:16:56 +0100
Date: Fri, 22 Jan 2010 12:16:56 +0100
From: Koos van den Hout <koos@kzdoos.xs4all.nl>
To: linux-dvb@linuxtv.org
Message-ID: <20100122111656.GA16884@kzdoos.xs4all.nl>
References: <mailman.1.1264158002.19393.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <mailman.1.1264158002.19393.linux-dvb@linuxtv.org>
Subject: [linux-dvb] Initial Scan Data for DVB channel scan,
	How to get Initial DVB	Scan  data
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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


> Hi ,
> Can anyone share the information, regarding "How initial scan data will
> generate"
> 
> from "dvb-apps->utils->scan",

> Is there any tool, which doesnt required any initial data for scanning dvb
> channels?

w_scan from http://wirbel.htpc-forum.de/w_scan/index_en.html

I have used this for dvb-t and it works great. According to its
documentation it should also work for dvb-c, I can just imagine that it
will take LONG.

                                           Koos

-- 
Koos van den Hout,           PGP keyid DSS/1024 0xF0D7C263 via keyservers
koos@kzdoos.xs4all.nl        or RSA/1024 0xCA845CB5
                                           Weather maps from free sources at
http://idefix.net/~koos/                          http://weather.idefix.net/

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
