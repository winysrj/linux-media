Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:37303 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZGATxp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jul 2009 15:53:45 -0400
Received: by qw-out-2122.google.com with SMTP id 9so538737qwb.37
        for <linux-media@vger.kernel.org>; Wed, 01 Jul 2009 12:53:48 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Jul 2009 15:53:48 -0400
Message-ID: <18b102300907011253s6a942be8jf09665a4c8bb8f9b@mail.gmail.com>
Subject: Sabrent TV-USBHD
From: James Klaas <jklaas@appalachian.dyndns.org>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I recently got one of these and I've been experimenting with it a little.

I downloaded the mercurial tree from around June 5, 2009 and patched
it using the patches here:
http://linuxtv.org/hg/~mkrufky/teledongle/rev/676e2f4475ed

I got it to compile fine and the drivers seem to load without
complaint.  I'm mostly interested in getting the QAM stuff to work.
Here's partial output from w_scan

-------------
$ w_scan -a1 -A3 -t3
w_scan version 20081106
-_-_-_-_ Getting frontend capabilities-_-_-_-_
frontend Auvitek AU8522 QAM/8VSB Frontend supports
FE_CAN_8VSB
FE_CAN_QAM_64
FE_CAN_QAM_256
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
57000:
...
597000:
603000:
609000: signal ok (ch88 QAM)
615000:
621000: signal ok (ch90 QAM)
627000:
633000: signal ok (ch92 QAM)
639000:
...
tune to:
----------no signal----------
tune to:  (no signal)
----------no signal----------
ERROR: Sorry - i couldn't get any working frequency/transponder
 Nothing to scan!!
dumping lists (0 services)
Done.
----------------

I'm curious to know why I get some "signal ok"s but when I tries to do
a "tune to", nothing seems to be there?  Also, this finds a much
smaller list of signals than my other cards.  I'm not sure where to
poke around to try getting this better, but I'm happy to test out code
anyone wants to throw my way.

James
