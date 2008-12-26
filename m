Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2a.orange.fr ([80.12.242.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kafifi@orange.fr>) id 1LGCKH-0000bJ-GK
	for linux-dvb@linuxtv.org; Fri, 26 Dec 2008 14:02:02 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2a23.orange.fr (SMTP Server) with ESMTP id 106E0700009B
	for <linux-dvb@linuxtv.org>; Fri, 26 Dec 2008 14:01:28 +0100 (CET)
Received: from pcserver (ASte-Genev-Bois-151-1-79-83.w81-48.abo.wanadoo.fr
	[81.48.108.83])
	by mwinf2a23.orange.fr (SMTP Server) with ESMTP id E31657000084
	for <linux-dvb@linuxtv.org>; Fri, 26 Dec 2008 14:01:27 +0100 (CET)
Received: from pcserver ([192.168.200.1]) by pcserver (602LAN SUITE 2004) id
	389d07e9 for linux-dvb@linuxtv.org; Fri, 26 Dec 2008 14:00:49 +0100
From: "kafifi" <kafifi@orange.fr>
To: <linux-dvb@linuxtv.org>
Date: Fri, 26 Dec 2008 14:00:48 +0100
MIME-Version: 1.0
In-Reply-To: <20081226114119.EFE221C00094@mwinf1921.orange.fr>
Message-Id: <20081226130127.E31657000084@mwinf2a23.orange.fr>
Subject: Re: [linux-dvb] "scan" doesn't tune on all dvb-t  multiplex
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi again,
I found the problem : sources.conf was incomplete and some parameters was
wrong.
To receive dvb-t from Eiffel Tower, here is the correct "sources.conf" I use
with vdr :

	# Paris - France - various DVB-T transmitters
	# Paris - Tour Eiffel      : 21 23 24 27 29 32 35   <<  updated by
me @ 26-12-2008
	# Paris Est - Chennevi=E8res : 35 51 54 57 60 63
	# Paris Nord - Sannois     : 35 51 54 57 60 63
	# Paris Sud - Villebon     : 35 51 56 57 60 63
	# T freq bw fec_hi fec_lo mod transmission-mode guard-interval
hierarchy

	# Canal 21
	T 474166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 23
	T 490166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 24
	T 498166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 27
	T 522166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 29
	T 538166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
	# Canal 32
	T 562166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 35
	T 586166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE

	# Canal 51
	T 714166000 8MHz 3/4 NONE QAM64 8k 1/8 NONE
	# Canal 54
	T 738166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 56
	T 754166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 57
	T 762166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 60
	T 786166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE
	# Canal 63
	T 810166000 8MHz 2/3 NONE QAM64 8k 1/32 NONE




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
