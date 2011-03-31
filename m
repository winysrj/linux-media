Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:30972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab1CaKpU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 06:45:20 -0400
Message-ID: <4D945B39.8050708@redhat.com>
Date: Thu, 31 Mar 2011 07:45:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: handygewinnspiel@gmx.de
CC: linux-media@vger.kernel.org
Subject: Re: [w_scan PATCH] Add Brazil support on w_scan
References: <4D909B59.9040809@redhat.com> <20110328172045.64750@gmx.net> <4D90D78F.7050308@redhat.com> <20110329201152.282620@gmx.net> <4D92697C.3030209@redhat.com>
In-Reply-To: <4D92697C.3030209@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-03-2011 20:21, Mauro Carvalho Chehab escreveu:
> Em 29-03-2011 17:11, handygewinnspiel@gmx.de escreveu:
>> So I changed it now to scan any srate for 6MHz networks, but skip over those which are unsupported by bandwidth limitation.
...
> Anyway, I'll test the today's version and reply if I detect any troubles on it.

Test results:

	$ ./w_scan -c BR -fc 
Took about 30 mins for scan. As the board I'm using doesn't support QAM_AUTO
for DVB-C, it seek only QAM_64. No channels detected.

	$ ./w_scan -c BR -fc -Q1
Took about 30 mins for scan. Channels were properly detected.

	$ ./w_scan -c BR -fc -Q1 -S13
Took about 10 mins for scan. Channels were properly detected.

IMHO, the default, if QAM_AUTO is not supported and -Q parameter is not used,
sould be to test for the most common QAM types, and not for just 64-QAM.
A search at dvb-apps transponders files (upstream + Net Digital Brazil DVB-C freq)
show:

$ grep -l QAM64 /home/v4l/dvb-apps/util/scan/dvb-c/*|wc
     31      31    1087
$ grep -l QAM256 /home/v4l/dvb-apps/util/scan/dvb-c/*|wc
     18      18     859
$ grep -l QAM128 /home/v4l/dvb-apps/util/scan/dvb-c/*|wc
      8       8     249
$ grep QAM /home/v4l/dvb-apps/util/scan/dvb-c/*|cut -d' ' -f 5|sort|uniq -c|sort -n -r
    372 QAM64
    179 QAM256
     72 QAM128

So, starting with QAM64 makes sense, but it makes sense also to test for
QAM256 and QAM128, if QAM_AUTO is not supported.

Cheers,
Mauro
