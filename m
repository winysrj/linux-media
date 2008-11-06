Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2b.orange.fr ([80.12.242.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Kxt8T-0000z3-W3
	for linux-dvb@linuxtv.org; Thu, 06 Nov 2008 01:54:11 +0100
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Thu, 6 Nov 2008 01:53:36 +0100
References: <491236F2.4050101@andrei.myip.org>
In-Reply-To: <491236F2.4050101@andrei.myip.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811060153.37102.hftom@free.fr>
Subject: Re: [linux-dvb] HD over satellite? (h.264)
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

Le jeudi 6 novembre 2008 01:14:42 Florin Andrei, vous avez =E9crit=A0:
> I am currently receiving SD programs, MPEG2 encoded, with a small
> receiver, and I plan to use a DVB-S card pretty soon with my MythTV box.
>
> But I noticed that the european TV network that I watch over satellite
> is now doing experiments with HD. They are testing HD broadcast over
> satellite, encoded with h.264. They call it DVB-S HD.
>
> Question: Are you aware of any receiver that can be used with Linux to
> capture DVB-S HD?

If it's DVB-S, any DVB-S device will.
If it's DVB-S2, you need a DVB-S2 device.

Playback of such channels requires some strong multicore cpu, coupled with =

latest ffmpeg svn.

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
