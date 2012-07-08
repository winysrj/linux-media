Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:37011 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862Ab2GHSdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jul 2012 14:33:17 -0400
Date: Sun, 8 Jul 2012 20:33:03 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: martin-eric.racine@iki.fi
Cc: Hans de Goede <hdegoede@redhat.com>, 677533@bugs.debian.org,
	linux-media@vger.kernel.org
Subject: Re: video: USB webcam fails since kernel 3.2
Message-ID: <20120708203303.26d13474@armhf>
In-Reply-To: <4FF9CA30.9050105@redhat.com>
References: <20120614162609.4613.22122.reportbug@henna.lan>
	<20120614215359.GF3537@burratino>
	<CAPZXPQd9gNCxn7xGyqj_xymPaF5OxvRtxRFkt+SsLs942te4og@mail.gmail.com>
	<20120616044137.GB4076@burratino>
	<1339932233.20497.14.camel@henna.lan>
	<CAPZXPQegp7RA5M0H9Ofq4rJ9aj-rEdg=Ly9_1c6vAKi3COw50g@mail.gmail.com>
	<4FF9CA30.9050105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 08 Jul 2012 19:58:08 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hmm, this is then likely caused by the new isoc bandwidth negotiation code
> in 3.2, unfortunately the vc032x driver is one of the few gspca drivers
> for which I don't have a cam to test with. Can you try to build your own
> kernel from source?

Hi Martin-Éric,

Instead of re-building the gspca driver from a kernel source, you may
try the gspca test tarball from my web site
	http://moinejf.free.fr/gspca-2.15.18.tar.gz
It contains most of the bug fixes, including the one about the
bandwidth problem.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
