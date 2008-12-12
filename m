Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-1.epublica.de ([213.238.59.6])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abos@hanno.de>) id 1LBC8B-0002Nb-1h
	for linux-dvb@linuxtv.org; Fri, 12 Dec 2008 18:48:52 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail-1.epublica.de (Postfix) with ESMTP id D0C9730453EB
	for <linux-dvb@linuxtv.org>; Fri, 12 Dec 2008 18:48:47 +0100 (CET)
Received: from mail-1.epublica.de ([127.0.0.1])
	by localhost (mail-1.rz.epublica.de [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id jHhNmjnPUOU7 for <linux-dvb@linuxtv.org>;
	Fri, 12 Dec 2008 18:48:47 +0100 (CET)
Received: from [192.168.178.41] (hmbg-4dba18e4.pool.einsundeins.de
	[77.186.24.228])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: hanno.zulla@hanno.de)
	by mail-1.epublica.de (Postfix) with ESMTP id 9E94C30453EA
	for <linux-dvb@linuxtv.org>; Fri, 12 Dec 2008 18:48:47 +0100 (CET)
Message-ID: <4942A3FF.3090203@hanno.de>
Date: Fri, 12 Dec 2008 18:48:47 +0100
From: Hanno Zulla <abos@hanno.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] How to debug skips & async with FF dvb card & vdr?
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

[This is an updated repost from the vdr mailing list,
there was no solution found there.]

Hi,

since upgrading to the most recent Ubuntu release 8.10 (Intrepid), my FF
card is having problems. It is async with audio, both for some live TV
channels and some recordings. It is also skipping while watching live
TV. (This is not a full diagnosis, but the skipping appears to be
limited to encrypted channels.) [1]

vdr didn't show this behaviour with the previous setup (based on Hardy
with default Ubuntu kernel).

However, the logs show nothing. Nothing at all.

So how can I debug this if the system thinks that everything is fine?

As suggested in [4], I have tried the most recent v4l drivers, already,
but that didn't help.

Thanks,

Hanno



Here's the setup:

Athlon X2 CPU

vdr 1.6.0-2, self-compiled e-tobi binary for Ubuntu Intrepid [2]
(e-tobi version number: 1.6.0-8)

Budget DVB-C card used as input,
with CAM and Kabel Deutschland smartcard,
using the driver that comes with Ubuntu's default 2.6.27 kernel
(problem persists with the most recent v4l driver)

FF DVB-C card without CAM, used as input and output,
using the ttpci driver that comes with Ubuntu's default 2.6.27 kernel
plus the modified firmware from [3]
(problem persists with the most recent v4l driver)


Links are mostly German:

[1] http://vdr-portal.de/board/thread.php?threadid=82518
[2] http://www.hanno.de/blog/category/vdr/
[3] http://www.vdr-portal.de/board/thread.php?threadid=59746
[4] http://www.linuxtv.org/pipermail/vdr/2008-December/018754.html


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
