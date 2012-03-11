Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:54845 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab2CKPsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 11:48:36 -0400
From: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: Mapping frontends to demuxes
Date: Sun, 11 Mar 2012 17:48:31 +0200
Cc: vlc-devel@videolan.org
References: <201203111608.48843.remi@remlab.net> <201203111725.58006.remi@remlab.net> <CAGoCfiwM_FPAbRhZf4UfiWU7XkY6_WvHzT-v9qyBF9nZ=HaR-A@mail.gmail.com>
In-Reply-To: <CAGoCfiwM_FPAbRhZf4UfiWU7XkY6_WvHzT-v9qyBF9nZ=HaR-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203111748.32004.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le dimanche 11 mars 2012 17:34:50 Devin Heitmueller, vous avez écrit :
> 2012/3/11 Rémi Denis-Courmont <remi@remlab.net>:
> > By the way, the bt8xx driver exposes ATSC but not ITU J.83 annex B. This
> > is contrary to all other ATSC frontends. Is this correct?
> 
> Many of the older cards didn't support J.83 annex B (i.e. ClearQAM).
> Whether the device supports ClearQAM or not is actually controlled by
> the demodulator driver, not the bridge driver.

Ah ok, thanks.

On the topic of J.83, what's the intended difference between SYS_ISDBC and 
SYS_DVBC_ANNEX_C ? (I cannot find any driver with SYS_ISDBC.)

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
