Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.229])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KVNvY-0000sr-CH
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 11:55:01 +0200
Received: by rv-out-0506.google.com with SMTP id b25so2582854rvf.41
	for <linux-dvb@linuxtv.org>; Tue, 19 Aug 2008 02:54:55 -0700 (PDT)
Message-ID: <7641eb8f0808190254n6ed70454wa190023a42e99592@mail.gmail.com>
Date: Tue, 19 Aug 2008 11:54:55 +0200
From: Beth <beth.null@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <7641eb8f0808180228y3446ca36y9ed9f770a3c2ec54@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808180228y3446ca36y9ed9f770a3c2ec54@mail.gmail.com>
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

Hi guys, I know that I am talking to myself but this is another test:

If I play the 100Mb file with vlc, it gives at the shell the following errors:


VLC media player 0.8.6e Janus
libdvbpsi error (PSI decoder): TS discontinuity (received 15, expected
0) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 10, expected
0) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 10, expected
8) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 4, expected
2) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 2, expected
1) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 2, expected
0) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 9, expected
8) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 12, expected
10) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 3, expected
2) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 0, expected
14) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 0, expected
15) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 0, expected
9) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 9, expected
1) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 9, expected
8) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 7, expected
6) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 0, expected
14) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected
4) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 0, expected
14) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 12, expected
10) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 8, expected
7) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected
5) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 2, expected
0) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 1, expected
0) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 12, expected
10) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 12, expected
11) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 14, expected
12) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 7, expected
6) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 12, expected
10) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected
4) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 11, expected
10) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 9, expected
8) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 14, expected
12) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 13, expected
12) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 11, expected
10) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 0, expected
14) for PID 1053
libdvbpsi error (PSI decoder): TS duplicate (received 0, expected 1) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 14, expected
13) for PID 0
libdvbpsi error (PSI decoder): TS discontinuity (received 6, expected
4) for PID 1053
libdvbpsi error (PSI decoder): TS discontinuity (received 2, expected
0) for PID 1053
libdvbpsi error (misc PSI): Bad CRC_32 (0x95b996cc) !!!
libdvbpsi error (PSI decoder): PSI section too long

So, it seems that it is losing packets, someone is getting fat eating
the data :D.

Seeee youuuu.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
