Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:55542 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388Ab3GLJJt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 05:09:49 -0400
Message-ID: <51DFC76B.6010208@schinagl.nl>
Date: Fri, 12 Jul 2013 11:07:55 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: opensource@till.name
Subject: Fwd: dtv-scan-tables tar archive
References: <20130712085956.GZ4000@genius.invalid>
In-Reply-To: <20130712085956.GZ4000@genius.invalid>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I think the archive is generated incorrectly. Could you take a look and 
see why? I shamefully admit I still am not sure where you did what to 
generate these ;)

Oliver


-------- Original Message --------
Subject: 	dtv-scan-tables tar archive
Date: 	Fri, 12 Jul 2013 10:59:56 +0200
From: 	Till Maas <opensource@till.name>
To: 	Oliver Schinagl <oliver@schinagl.nl>



Hi Oliver,

the tar archives at
http://linuxtv.org/downloads/dtv-scan-tables/
are broken.
xxd dtv-scan-tables-2013-04-12-495e59e.tar | less shows:

| 0000000: 6769 7420 6172 6368 6976 6520 2d2d 666f  git archive --fo
| 0000010: 726d 6174 2074 6172 202d 2d70 7265 6669  rmat tar --prefi
| 0000020: 7820 2f75 7372 2f73 6861 7265 2f64 7662  x /usr/share/dvb
| 0000030: 2f20 4845 4144 0a70 6178 5f67 6c6f 6261  / HEAD.pax_globa
| 0000040: 6c5f 6865 6164 6572 0000 0000 0000 0000  l_header........

It seems like the git archive commandline somehow ended in the tarball.
E.g. the tarball should start with pax_global_header and not with "git
archive".

Regards
Till



