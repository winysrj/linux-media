Return-path: <linux-media-owner@vger.kernel.org>
Received: from tricon.hu ([195.70.57.4]:43941 "EHLO tricon.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZHSHmr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 03:42:47 -0400
Date: Wed, 19 Aug 2009 09:42:42 +0200
From: =?ISO-8859-2?Q?P=E1sztor_Szil=E1rd?= <don@tricon.hu>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Anysee E30 C Plus + MPEG-4?
Message-Id: <20090819094242.50ae2a03.don@tricon.hu>
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAACX9qQa/LtVPmfnAK0XM/DwChwAAEAAAAAZ+O15rAjRKhc61nu2RPHIBAAAAAA==@tv-numeric.com>
References: <20090818170820.3d999fb9.don@tricon.hu>
	<alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva>
	<20090818210107.2a6a5146.don@tricon.hu>
	<!&!AAAAAAAAAAAYAAAAAAAAACX9qQa/LtVPmfnAK0XM/DwChwAAEAAAAAZ+O15rAjRKhc61nu2RPHIBAAAAAA==@tv-numeric.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thierry Lelegard:
> Stream type 0x1B precisely means AVC / H.264 video stream (cf. ISO
> 138181-1:2000/FDAM 3)
> 
> Try VLC instead of mplayer. VLC does render H.264 HD video, provided you
> have a (very) good CPU.

Thanks for the info. Anyway, mplayer also does render H.264 of course, it's
the stream that's not very cleverly muxed, it seems. And with mplayer I have
vdpau acceleration on my nvidia card that can render 1920x1080@50 fps in real
time.

s.

   -------------------------------------------------------------------------
   |  After all is said and done, a hell of a lot more is said than done.  |
   -------------------------------------------------------------------------
