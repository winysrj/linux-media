Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qw-out-2122.google.com ([74.125.92.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LERDh-0005fB-Mb
	for linux-dvb@linuxtv.org; Sun, 21 Dec 2008 17:31:59 +0100
Received: by qw-out-2122.google.com with SMTP id 9so583591qwb.17
	for <linux-dvb@linuxtv.org>; Sun, 21 Dec 2008 08:31:53 -0800 (PST)
Message-ID: <412bdbff0812210831w2c8930eal5181c766857b0aa8@mail.gmail.com>
Date: Sun, 21 Dec 2008 11:31:53 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Holger Rusch" <holger@rusch.name>
In-Reply-To: <494E61B4.2040006@rusch.name>
MIME-Version: 1.0
Content-Disposition: inline
References: <cae4ceb0812091511s668dcc5fj793e7efc113fedfd@mail.gmail.com>
	<493F8A81.7040802@rusch.name> <494E61B4.2040006@rusch.name>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy DT USB XS Diversity (Quality with
	linux worse then with Windows)
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

On Sun, Dec 21, 2008 at 10:33 AM, Holger Rusch <holger@rusch.name> wrote:
> Shameless repost. No idea? Anybody?

Hello Holger,

Are you using the latest code from http://linuxtv.org/hg/v4l-dvb,
including the newer 1.20 firmware?

Have you tried turning off the LNA and see if there is any difference
in SNR?  While an amplifier can be a good thing in some cases, if
you're to close to the transmitter the LNA may be driving the signal
too hard for the demodulator.

Is the SNR level always being reported as poor, or only when the
signal is dropping out?

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
