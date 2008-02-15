Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JQ6PO-0000VH-VT
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 20:39:42 +0100
Received: by fk-out-0910.google.com with SMTP id z22so884723fkz.1
	for <linux-dvb@linuxtv.org>; Fri, 15 Feb 2008 11:39:41 -0800 (PST)
Message-ID: <47B5EA79.8010402@googlemail.com>
Date: Fri, 15 Feb 2008 19:39:37 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Tools to edit TS files
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

I'd like to edit TS files (recorded with gnutv for instance).
Basically I'd like to cut, paste and join to skip commercials.

Is there a tool for that out there?

Otherwise I was thinking of writing one.
I understand that I must cut on a 188 bytes boundary and that should be the only requirement.

1) Reading the Transport Stream page on wikipedia, it seems there is a timer PCR. Can I use it to 
know about the time?
2) Can I cut at the end of a frame so I avoid spurious frames in the first seconds?

But again, does anybody know a tool for that?

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
