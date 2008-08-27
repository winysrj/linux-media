Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timcumming123@googlemail.com>) id 1KYLf0-000335-1W
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 16:06:11 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1775418fka.1
	for <linux-dvb@linuxtv.org>; Wed, 27 Aug 2008 07:06:06 -0700 (PDT)
Message-ID: <e42dc1490808270706r5f989df5l1a877fcf08a7827@mail.gmail.com>
Date: Wed, 27 Aug 2008 15:06:06 +0100
From: "Tim Cumming" <timcumming123@googlemail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <e42dc1490808260402i153cbbfj9beb18481caeac9d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <e42dc1490808260402i153cbbfj9beb18481caeac9d@mail.gmail.com>
Subject: Re: [linux-dvb] WinTV-Nova-T usb2 64bit
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

Just a quick update. I have since set up a serial console to remote
log the events, and have found early on in the errors:

Aug 27 14:35:02 legend kernel: dvb-usb: bulk message failed: -110 (2/0)
Aug 27 14:35:02 legend kernel: dvb-usb: bulk message failed: -110 (2/0)
Aug 27 14:35:04 legend kernel: dvb-usb: bulk message failed: -110 (3/0)
Aug 27 14:35:04 legend kernel: dvb-usb: error while stopping stream.
Aug 27 14:35:04 legend kernel: dvb-usb: bulk message failed: -110 (2/0)
Aug 27 14:35:04 legend kernel: dvb-usb: bulk message failed: -110 (6/0)

After this the flood continues, to rescue the system I have to stop
mythbackend, then remove the dvb_usb_nova_t_usb2 module, disconnect
the tuners, then reconnect and restart mythbackend.


Tim.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)
Comment: http://getfiregpg.org

iEYEARECAAYFAki1XrYACgkQ+3B4KcqycetfCwCgnND7qg5ufwkG4X9T4AO9ZJHr
kfsAoJ4aaKthDkGug3BX5vwwC5FPKbNr
=bZWB
-----END PGP SIGNATURE-----
2008/8/26 Tim Cumming <timcumming123@googlemail.com>
>
> I have recently upgraded my hardware from 32bit to 64bit, and am now
> experiencing issues with my Hauppage WinTV Nova-T usb2's.
> I have been searching through the mail lists and googling, but with no
> luck. I should also mention there is an old WinTV Nova-T pci in the
> system working fine.
> My problem is that when the usb devices are in use will they work
> periodically, but randomly produce a flood of messages ending in
> alternate:
>
> dvb-usb: bulk message failed: -110 (2/0)
> dvb-usb: bulk message failed: -110 (6/0)
>
> These are old style Nova-T usb2's:
>
> [mythtv@legend ~]$ /sbin/lsusb
> Bus 001 Device 014: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)
> Bus 001 Device 012: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)
> Bus 001 Device 010: ID 2040:9301 Hauppauge WinTV NOVA-T USB2 (warm)
>
> The machine is an AMD Phenom 9850 Quad-Core running Fedora 9 and
> mythtv. I can provide further details if required, and also details of
> the previously working machine. (Although it was a 32bit system).
>
> Regards,
>
> Tim Cumming.
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
