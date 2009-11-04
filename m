Return-path: <linux-media-owner@vger.kernel.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]:60609
	"EHLO alefors.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736AbZKDNFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 08:05:47 -0500
Received: from TERMINAL1 ([10.0.0.1]:45063)
	by alefors.se with [XMail 1.26 ESMTP Server]
	id <S15F> for <linux-media@vger.kernel.org> from <magnus@alefors.se>;
	Wed, 4 Nov 2009 14:05:49 +0100
From: =?iso-8859-1?Q?Magnus_H=F6rlin?= <magnus@alefors.se>
To: <linux-media@vger.kernel.org>
Subject: SV: TT S2-1600 and NOVA-HD-S2 tuning problems on some transponders
Date: Wed, 4 Nov 2009 14:05:49 +0100
Message-ID: <000c01ca5d4f$88aeff50$9b65a8c0@Sensysserver.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4AF16351.1040409@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Ursprungligt meddelande-----
> Från: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] För Andreas Regel
> Skickat: den 4 november 2009 12:20
> Till: Magnus Hörlin
> Kopia: linux-media@vger.kernel.org
> Ämne: Re: TT S2-1600 and NOVA-HD-S2 tuning problems on some transponders
> 
> Hi Magnus,
> 
> Magnus Hörlin schrieb:
> > The S2-1600's are more inconsistent. They have problems tuning to 11421,
> > 12130, 12226 and 12341 MHz. Sometimes they do and once locked, they run
> > forever with perfect reception. I don't understand why there's a problem
> > with these transponders since they tune just fine to transponders with
> the
> > same SR, polarisation and nearby frequencies. Very greateful for any
> input.
> 
> The stv090x driver as it is in current hg repository has some known issues
> with locking reliability.
> 
> Please try the patches that I sent two days ago to the list.
> 
> Andreas
> --

Hi Andreas, this is just brilliant! I really should read vdrportal more
often. Tried http://powarman.dyndns.org/hg/v4l-dvb and my S2-1600's now lock
every time on every transponder, and fast. Just ordered two more and will
ditch my NOVA-HD-S2.
Again, thanks a lot.
/Magnus


