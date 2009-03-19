Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:40458 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbZCSHGn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 03:06:43 -0400
Date: Thu, 19 Mar 2009 07:59:21 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: svwindbird <svwindbird@gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: gspca/v4l - HP Webcam 1.3 - Device Request
Message-ID: <20090319075921.0a1156d3@free.fr>
In-Reply-To: <49C0ECD9.10405@gmai.com>
References: <49C0ECD9.10405@gmai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Mar 2009 06:45:13 -0600
svwindbird <svwindbird@gmail.com> wrote:

> Hope this is the correct place for requesting to add a device.
> I'm also assuming that it's a gspca/VC032x driver problem, as it's
> counter-part in windows in usbvm326.
> 
> Name: HP Webcam 1.3 Megapixal (USB)
> Model: rd345aa
> USB_id: 15b8:6001
> Env: Suse 11.1 (Kernel 2.6.27 64bit)
>      uname: Linux liana 2.6.27.19-3.2-default #1 SMP 2009-02-25
> 15:40:44 +0100 x86_64 x86_64 x86_64 GNU/Linux
>      v4l 0.5.8-0 (packaged with Suse)...
>         (hacked from gspca-3b1ce192115d.tar.bz2) (d/l'ed from linuxtv)
>      Toshiba P205D-7438 AMD Athlon X2 - see lspci output at bottom for
>         for info
> 
> Synopsis:
> Runs with driver usbvm326 under windows.
> tried hacking VC032x.c, forcing use of...
> BRIDGE_VC0323 = got a constant framebuffer overruns, then tried,
> BRIDGE_VC0321 = ran, but picture out of sync and possibly b/w picture
> (hard to tell). Sorry, but my so-called expertise stops about here.

Hello Diana,

I have one ms-win usbvm326.inf, but it deals with 15b8:6001 only and it
includes USB code for the sensors hv7131r and po1200. Does your
usbvm326 include other sensors? (look at the 'HKR,%xxxx%, Init...'
lines)

You sent some traces, but they don't show information from the vc032x
subdriver. Have you such traces that give indications about the sensor?

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
