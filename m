Return-path: <linux-media-owner@vger.kernel.org>
Received: from 78.218.95.91.static.ter-s.siw.siwnet.net ([91.95.218.78]:44158
	"EHLO alefors.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZKDKh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2009 05:37:26 -0500
Received: from TERMINAL1 ([10.0.0.1]:60008)
	by alefors.se with [XMail 1.26 ESMTP Server]
	id <S153> for <linux-media@vger.kernel.org> from <magnus@alefors.se>;
	Wed, 4 Nov 2009 11:37:27 +0100
From: =?iso-8859-1?Q?Magnus_H=F6rlin?= <magnus@alefors.se>
To: <linux-media@vger.kernel.org>
Subject: TT S2-1600 and NOVA-HD-S2 tuning problems on some transponders
Date: Wed, 4 Nov 2009 11:37:19 +0100
Message-ID: <000001ca5d3a$c9a65d10$9b65a8c0@Sensysserver.local>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi. I have two S2-1600 and one NOVA-HD-S2 with a quad LNB at 1.0W
(http://www.lyngsat.com/packages/canaldigital.html) and excellent reception
on most transponders running 2.6.31.1 and dvb drivers from latest hg. I have
troubles with both cards, though.
The NOVA-HD-S2 does not lock on transponders with SR's of 25000 and 30000,
but on all others (24500,27800,28000). Any ideas what causes that? The 30000
I can understand, but 25000?
The S2-1600's are more inconsistent. They have problems tuning to 11421,
12130, 12226 and 12341 MHz. Sometimes they do and once locked, they run
forever with perfect reception. I don't understand why there's a problem
with these transponders since they tune just fine to transponders with the
same SR, polarisation and nearby frequencies. Very greateful for any input.
Best regards and thanks to all involved in LinuxTV,
/Magnus H


