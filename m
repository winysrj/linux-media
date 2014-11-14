Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:54356 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934378AbaKNLIE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 06:08:04 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Cc: "hans.verkuil" <hans.verkuil@cisco.com>,
	Linux Media <linux-media@vger.kernel.org>
References: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
Date: Fri, 14 Nov 2014 12:00:59 +0100
In-Reply-To: <CAM_ZknVTqh0VnhuT3MdULtiqHJzxRhK-Pjyb58W=4Ldof0+jgA@mail.gmail.com>
	(Andrey Utkin's message of "Tue, 11 Nov 2014 19:46:46 +0200")
MIME-Version: 1.0
Message-ID: <m3sihmf3mc.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: [RFC] solo6x10 freeze, even with Oct 31's linux-next... any ideas or help?
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey.utkin@corp.bluecherry.net> writes:

> The problem is the following: after ~1 hour of uptime with working
> application reading the streams, one card (the same one every time)
> stops producing interrupts (counter in /proc/interrupts freezes), and
> all threads reading from that card hang forever in
> ioctl(VIDIOC_DQBUF).

There is a race condition in the IRQ handler, at least in 3.17.
I don't know if it's related, will post a patch.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
