Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1KMNlc-0001aj-Lz
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 15:55:34 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id DD478E6AA0
	for <linux-dvb@linuxtv.org>; Fri, 25 Jul 2008 15:55:28 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id sJAcB8GQlZC6 for <linux-dvb@linuxtv.org>;
	Fri, 25 Jul 2008 15:55:28 +0200 (CEST)
Received: from [172.22.22.60] (ip-81-210-158-210.hsi.iesy.net [81.210.158.210])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id 44136E6A99
	for <linux-dvb@linuxtv.org>; Fri, 25 Jul 2008 15:55:28 +0200 (CEST)
Message-ID: <4889DB50.7040809@linuxtv.org>
Date: Fri, 25 Jul 2008 15:55:28 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <3a665c760807240246x7bb3d442lac2b407dd138accf@mail.gmail.com>	<200807241153.55596.Nicola.Sabbi@poste.it>	<3a665c760807250212i1902e4fdud47da351262c140f@mail.gmail.com>	<200807251116.54407.Nicola.Sabbi@poste.it>
	<4889D176.1030702@gmx.de>
In-Reply-To: <4889D176.1030702@gmx.de>
Subject: Re: [linux-dvb] question about definition of section in PSI
 of	Transport stream
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

Andreas Regel wrote:
> PMTs are always just one section. PATs could have more than one but that 
> would normally need more than 250 programmes on one TS, so it's not that 
> easy to find a TS with multi section PATs. Other tables, like NIT or SDT 
> often are bigger than 1024 bytes and split over several sections.

IIRC there were some radio channels called "Les Radios" sharing one PMT
PID with the same service id on Astra 19.2E some years ago. I think
they're now called Canalsat Radios. Maybe they still have PMTs with
multiple sections. See http://www.satindex.de/paytv/cs-france/ .

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
