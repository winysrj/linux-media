Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:54451 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbZG1GxI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 02:53:08 -0400
Date: Tue, 28 Jul 2009 08:52:58 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Denis Loginov <dinvlad@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: Patch for drivers/media/video/gspca/sonixj.c (new device added)
Message-ID: <20090728085258.4242e434@tele>
In-Reply-To: <200907252311.37511.dinvlad@gmail.com>
References: <200907252311.37511.dinvlad@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 25 Jul 2009 23:11:37 +0300
Denis Loginov <dinvlad@gmail.com> wrote:

> Hello. Included is a patch allowing to use DIGITUS DA-70811 webcam,
> also known as ZSMC USB PC Camera ZS211 (with idVendor name = Microdia
> in lsusb).
	[snip]
> Tested on kernel 2.6.29, works fine for a cheap model.
> The only open question is what value for the bridge should be used:
> SN9C110, SN9C120, or SN9C325 (camera works well with any of them).

Hello Denis,

Thanks. I applied your patch but you should have do it in a standard
way ('diff -u ..' was lacking as your Signed-off-by:).

About the bridge, the ms-win file snpstd3.inf says sn9c120b...

BTW, don't use the video4linux-list mailing list anymore. The new list
is linux-media@vger.kernel.org.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
