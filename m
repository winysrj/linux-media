Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from smtp25.orange.fr ([193.252.22.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1JQ6hE-0001RO-1u
	for linux-dvb@linuxtv.org; Fri, 15 Feb 2008 20:58:08 +0100
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2524.orange.fr (SMTP Server) with ESMTP id 344241C0009D
	for <linux-dvb@linuxtv.org>; Fri, 15 Feb 2008 20:57:37 +0100 (CET)
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Fri, 15 Feb 2008 20:56:55 +0100
References: <47B5EA79.8010402@googlemail.com>
In-Reply-To: <47B5EA79.8010402@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802152056.55250.hftom@free.fr>
Cc: Andrea <mariofutire@googlemail.com>
Subject: Re: [linux-dvb] Tools to edit TS files
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le vendredi 15 f=E9vrier 2008 20:39, Andrea a =E9crit=A0:
> Hi,
>
> I'd like to edit TS files (recorded with gnutv for instance).
> Basically I'd like to cut, paste and join to skip commercials.
>
> Is there a tool for that out there?
>
> Otherwise I was thinking of writing one.
> I understand that I must cut on a 188 bytes boundary and that should be t=
he
> only requirement.
>
> 1) Reading the Transport Stream page on wikipedia, it seems there is a
> timer PCR. Can I use it to know about the time?
> 2) Can I cut at the end of a frame so I avoid spurious frames in the first
> seconds?
>
> But again, does anybody know a tool for that?

http://project-x.sourceforge.net/

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
