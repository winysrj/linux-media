Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:44577 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab2EFSmi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 14:42:38 -0400
Date: Sun, 6 May 2012 20:43:47 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: gspca zc3xx - JPEG quality / frame overflow
Message-ID: <20120506204347.6d1a7af9@tele>
In-Reply-To: <4FA6C024.9090408@redhat.com>
References: <20120505205409.312e271f@tele>
	<4FA6C024.9090408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 06 May 2012 20:17:08 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> > - as it is (read the register 11 every 100 ms), the work queue is
> >    usefull when there is no polling of the snapshot button, because the
> >    frame overflow is reported as the bit 0 in the forth byte (data[3])
> >    of the interrupt messages.  
> 
> Interesting, so if the interrupt is enabled, then as soon as an overflow
> happens, we get notified through the interrupt data?
> 
> That may be an alternative to the worker thread, although the current
> solution does work rather well, so I wonder if we should meddle with it.

Hi Hans,

Indeed, your solution works, but it does double polling, and the actual
worker thread asks for a USB exchange each 100 ms. When using only the
interrupt message, there is no overhead.

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
