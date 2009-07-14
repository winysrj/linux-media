Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45347 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755314AbZGNWdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jul 2009 18:33:14 -0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 15 Jul 2009 00:33:09 +0200
From: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20090714223309.79880@gmx.net>
MIME-Version: 1.0
Subject: Re: DiSEqC 2.x and HVR-4000
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> As far as I know the hardware of the Hauppauge HVR-4000 (cx24114 demod)

typo: it is cx24116

>supports DiSEqC 2.x, but there seems to be no implementation
>of diseqc_recv_slave_reply to obtain the messages from the slaves.
>DiSEqC 1.x works fine as far as I can tell.
>
>Grepping for slave_reply implementations in v4l-dvb only shows s5h1420, 
>stb0899, stv0900 and stv090x.
>
>Can anyone help?
>
>Thanks,
>Hans
-- 
Release early, release often.

GRATIS für alle GMX-Mitglieder: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://portal.gmx.net/de/go/maxdome01
