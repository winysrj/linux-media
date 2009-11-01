Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:60632 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZKALuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Nov 2009 06:50:25 -0500
Received: by pzk26 with SMTP id 26so2720925pzk.4
        for <linux-media@vger.kernel.org>; Sun, 01 Nov 2009 03:50:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380910310923nf45eba5o29083127328c5d47@mail.gmail.com>
References: <4AEC2F03.6050205@gmail.com>
	 <829197380910310923nf45eba5o29083127328c5d47@mail.gmail.com>
Date: Sun, 1 Nov 2009 22:50:30 +1100
Message-ID: <ee0ad0230911010350x4af7aae7q8640f85a08d2f4ab@mail.gmail.com>
Subject: Re: [linux-dvb] somebody messed something on xc2028 code?
From: Damien Morrissey <damien@damienandlaurel.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Nov 1, 2009 at 3:23 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
>
> On Sat, Oct 31, 2009 at 8:35 AM, Albert Comerma
> <albert.comerma@gmail.com> wrote:
> > Hi all, I just updated my ubuntu to karmic and found with surprise that with
> > 2.6.31 kernel my device does not work... It seems to be related to the
> > xc2028 code part since the kernel explosion happens when you try to tune the
> > device, here it's my dmesg, any idea?
> >
> > Albert
>
> Oh, you're using the stock 2.6.31 which didn't get my fix yet.  Please
> try the latest v4l-dvb tree and see if it still happens.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

Might this have something to with problems that I am having with the
Dvico dual digital 4 with karmic?
