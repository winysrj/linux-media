Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51702 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755239AbZKDLTl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Nov 2009 06:19:41 -0500
Message-ID: <4AF16351.1040409@gmx.de>
Date: Wed, 04 Nov 2009 12:19:45 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Magnus_H=F6rlin?= <magnus@alefors.se>
CC: linux-media@vger.kernel.org
Subject: Re: TT S2-1600 and NOVA-HD-S2 tuning problems on some transponders
References: <000001ca5d3a$c9a65d10$9b65a8c0@Sensysserver.local>
In-Reply-To: <000001ca5d3a$c9a65d10$9b65a8c0@Sensysserver.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Magnus,

Magnus Hörlin schrieb:
> The S2-1600's are more inconsistent. They have problems tuning to 11421,
> 12130, 12226 and 12341 MHz. Sometimes they do and once locked, they run
> forever with perfect reception. I don't understand why there's a problem
> with these transponders since they tune just fine to transponders with the
> same SR, polarisation and nearby frequencies. Very greateful for any input.

The stv090x driver as it is in current hg repository has some known issues with locking reliability.

Please try the patches that I sent two days ago to the list.

Andreas
