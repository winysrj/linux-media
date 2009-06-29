Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:40097 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZF2LKR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 07:10:17 -0400
Date: Mon, 29 Jun 2009 13:10:07 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Problem with 046d:08af Logitech Quickcam Easy/Cool - broken
 with in-kernel drivers, works with gspcav1
Message-ID: <20090629131007.6bc13b08@free.fr>
In-Reply-To: <200906291254.34727.PeterHuewe@gmx.de>
References: <200906281514.10689.PeterHuewe@gmx.de>
	<200906291230.09550.PeterHuewe@gmx.de>
	<20090629124034.5c43001c@free.fr>
	<200906291254.34727.PeterHuewe@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Jun 2009 12:54:34 +0200
Peter Hüwe <PeterHuewe@gmx.de> wrote:

> /usr/lib is just a link to /usr/lib64 - 
> $ ls -lahd /usr/lib
>   lrwxrwxrwx 1 root root 5 20. Dez 2008  /usr/lib -> lib64
> 
> but I tried it explicitly with both versions:
> ERROR: ld.so: object '/usr/lib32/libv4l/v4l1compat.so' from
> LD_PRELOAD cannot be preloaded: ignored.
> ERROR: ld.so: object '/usr/lib32/libv4l/v4l1compat.so' from
> LD_PRELOAD cannot be preloaded: ignored.
> 
> ERROR: ld.so: object '/usr/lib64/libv4l/v4l1compat.so' from
> LD_PRELOAD cannot be preloaded: ignored.
> 
> Seems I have to wait till skype releases a v4l2 compatible skype
> binary - but regarding the development cycle of skype this will
> be ... ahem ... never :)

It is not a skype problem but a loader problem. If you have both the 32
and 64 bits libraries, it means that your skype is statically linked
(you may check it by 'file /usr/bin/skype'). Then, get a dynamically
linked version.

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
