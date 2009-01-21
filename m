Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:35815 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbZAUTFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 14:05:05 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by smtp4-g21.free.fr (Postfix) with ESMTP id D390E4C82A3
	for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 20:04:59 +0100 (CET)
Received: from localhost (lns-bzn-57-82-249-43-204.adsl.proxad.net [82.249.43.204])
	by smtp4-g21.free.fr (Postfix) with ESMTP id CD9EC4C80C5
	for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 20:04:56 +0100 (CET)
Date: Wed, 21 Jan 2009 19:47:22 +0100
From: Jean-Francois Moine <moinejf@free.fr> (by way of Jean-Francois
	Moine <moinejf@free.fr>)
To: "T.P. Reitzel" <4066724035@vzwmail.net>
Message-ID: <20090121194722.1bf866b4@free.fr>
In-Reply-To: <49767CAB.8030004@vzwmail.net>
References: <49767CAB.8030004@vzwmail.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: gspca_spca505
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Jan 2009 18:38:51 -0700
"T.P. Reitzel" <4066724035@vzwmail.net> wrote:

> Original linux driver for Intel PC Camera Pro (see link for more
> detail):
> 
> http://sourceforge.net/projects/spca50x

The gspca v2 comes from this driver, so, it should work the same, but
some bug(s) may have been inserted.

> Intel's webpage for Intel Pro PC Camera (internal capture card):
> 
> http://downloadcenter.intel.com/filter_results.aspx?strTypes=all&ProductID=459&OSFullName=Windows*+98+SE&lang=eng&strOSs=18&submit=Go!

They give the M$-windows driver, but no Linux driver, and there is no
documentation on how to program the chip.

> P.S. I'm using libv4l version 0.5.7

I got your files, but the kernel.txt does not contain any spca
information. May you set the gspca debug flag to 0x3f, run 'svv -rg'
and send me the result of:

	grep spca /var/log/kern.log

Thank you.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
