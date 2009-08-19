Return-path: <linux-media-owner@vger.kernel.org>
Received: from [194.250.18.140] ([194.250.18.140]:34412 "EHLO tv-numeric.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751375AbZHSHh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2009 03:37:57 -0400
From: "Thierry Lelegard" <thierry.lelegard@tv-numeric.com>
To: <linux-media@vger.kernel.org>, <linux-dvb@linuxtv.org>
References: <20090818170820.3d999fb9.don@tricon.hu><alpine.DEB.2.01.0908181959241.27276@ybpnyubfg.ybpnyqbznva> <20090818210107.2a6a5146.don@tricon.hu>
Subject: RE: [linux-dvb] Anysee E30 C Plus + MPEG-4?
Date: Wed, 19 Aug 2009 09:17:59 +0200
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAACX9qQa/LtVPmfnAK0XM/DwChwAAEAAAAAZ+O15rAjRKhc61nu2RPHIBAAAAAA==@tv-numeric.com>
MIME-Version: 1.0
In-Reply-To: <20090818210107.2a6a5146.don@tricon.hu>
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Pásztor Szilárd:
> With scan -vv I could find the video PIDs
> for the HD channels and indeed they were missing in my channels.conf (values
> were 0) as scan detected them as "OTHER", but with a "type 0x1b" addition with
> which I don't know what to do for the time being...

Stream type 0x1B precisely means AVC / H.264 video stream (cf. ISO 138181-1:2000/FDAM 3)

Try VLC instead of mplayer. VLC does render H.264 HD video, provided you have a (very) good CPU.

-Thierry

