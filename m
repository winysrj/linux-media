Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:49342 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZLNIhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2009 03:37:16 -0500
Date: Mon, 14 Dec 2009 09:37:30 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS,
 2.6.16-2.6.21: ERRORS
Message-ID: <20091214093730.75a5a0a2@tele>
In-Reply-To: <4B2552A4.5090901@freemail.hu>
References: <200912131922.nBDJMMUm030337@smtp-vbr6.xs4all.nl>
	<4B2552A4.5090901@freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 13 Dec 2009 21:46:28 +0100
Németh Márton <nm127@freemail.hu> wrote:

> It seems that kernels before 2.6.24 (inclusively) do not have
> "__devinitconst", so  conex.c and etoms.c can only build with 2.6.25
> and later. Should USB_GSPCA_CONEX and USB_GSPCA_ETOMS be added to
> v4l/versions.txt?

The fix is not the right one. Some other gspca subdrivers use
"__devinitconst" (pac7302, pac7311, sonixb and spca506). The fix is to
define the macro for kernels < 2.6.25:

diff -r 174ad3097f17 linux/drivers/media/video/gspca/gspca.h
--- a/linux/drivers/media/video/gspca/gspca.h   Sun Dec 13 18:11:07
2009 +0100
+++ b/linux/drivers/media/video/gspca/gspca.h   Mon Dec 14 09:28:51
2009 +0100 @@ -11,6 +11,10 @@ /* compilation option */
 #define GSPCA_DEBUG 1
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 25)
+#define __devinitconst __section(.devinit.rodata)
+#endif
+
 #ifdef GSPCA_DEBUG
 /* GSPCA our debug messages */
 extern int gspca_debug;

I will ask to upload the changeset (actually in my test repository) as
soon as it is validated (i.e. if it works with hal).

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
