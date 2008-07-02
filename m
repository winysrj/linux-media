Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <owen.townend@gmail.com>) id 1KDwfo-0008Mc-4u
	for linux-dvb@linuxtv.org; Wed, 02 Jul 2008 09:22:41 +0200
Received: by wa-out-1112.google.com with SMTP id n7so158946wag.13
	for <linux-dvb@linuxtv.org>; Wed, 02 Jul 2008 00:22:33 -0700 (PDT)
Message-ID: <bb72339d0807020022n5694d177k7243ec0d0838659c@mail.gmail.com>
Date: Wed, 2 Jul 2008 17:22:33 +1000
From: "Owen Townend" <owen.townend@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Wiki Entry for AVerMedia AverTV Hybrid+FM PCI A16D
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
  I have recently bought an AVerMedia AverTV Hybrid+FM PCI A16D and
tried a few ways to get it working and ultimately the linuxtv
mercurial repository[1] combined with the xc3028-v27.fw firmware works
quite well. Whilst trying the mcentral repository[2] I contributed a
little to the wiki page[3]. Since settling on the linuxtv repo I was
looking to see if I could contribute anything and found that the
linuxtv wiki page[4] has only a link to the mcentral page though I can
see dev work for this device in the hg logs[5] since the initial
merge/import of Markus' mcentral code.

The wiki entry text is:
'Projectsite moved to: mcentral.de since it contains code which is
only available on that server.'

  In using the two diferent repositories the two builds have different
quirks and ask for different firmware. Does the dev for this device
still mainly consist of merging Markus' code and hence the wiki page
should be left as is or should I/we/someone seed the linuxtv wiki page
with instructions in using the linuxtv repo with this device?

  I am willing to type up instructions based on my experiences and can
take my own photos but am unsure whether the information would be
redundant and/or whether it would be helpful to do so.

cheers,
Owen.

P.S.
Thanks to Markus, Mauro, Tim and Dan for the work getting this working!
(names from the hg logs)

footnotes:
--
[1] hg repo: http://linuxtv.org/hg/v4l-dvb
[2] hg repo: http://mcentral.de/hg/~mrec/v4l-dvb-kernel
[3] wiki page: http://mcentral.de/wiki/index.php5/AVerMedia_AverTV_Hybrid_FM_PCI_A16D
[4] wiki page: http://www.linuxtv.org/v4lwiki/index.php/AVerMedia_AverTV_Hybrid%2BFM_PCI_A16D
[5] hg logs: http://linuxtv.org/hg/v4l-dvb/log?rev=avermedia+A16D

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
