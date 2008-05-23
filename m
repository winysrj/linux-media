Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4N75hQf026645
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 03:05:43 -0400
Received: from rs25s12.datacenter.cha.cantv.net
	(rs25s12.datacenter.cha.cantv.net [200.44.33.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4N75E0n008307
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 03:05:19 -0400
From: Emilio Lazo Zaia <emiliolazozaia@gmail.com>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	video4linux-list@redhat.com
In-Reply-To: <4820BD94.90005@t-online.de>
References: <88771.83842.qm@web83107.mail.mud.yahoo.com>
	<1209512868.5699.32.camel@palomino.walls.org>
	<1209863718.546.24.camel@localhost.localdomain>
	<481E1AD3.2060304@t-online.de>
	<1210045099.21581.6.camel@localhost.localdomain>
	<4820BD94.90005@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 23 May 2008 02:34:48 -0430
Message-Id: <1211526288.12831.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: MCE TV Philips 7135 Cardbus don't work
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi!

El mar, 06-05-2008 a las 22:20 +0200, Hartmut Hackmann escribió:

> But before you open the module, you might try a "modprobe saa7134 card=55"
> and watch the kernel log. If the driver tells you it found a tda8175(a),
> we already learned a lot.

With card=53 (ASUS TV-FM 7135) and tuner=54 (tda8290+75) radio works!
but seems to be swapped Television and Composite modes; I can watch RCA
input using _Television_ mode and switching to Composite mode shows
typical TV noise. Obviously the channel can't be changed in Composite
but there is a way to correct this input mode confusion?

There is a lag when radio station is changed, maybe because of a
card/tuner misconfiguration but works and ALSA audio capture function
also works!
-- 
Emilio Lazo Zaia <emiliolazozaia@gmail.com>
Facultad de Ciencias, UCV

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
