Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab0FSS5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jun 2010 14:57:06 -0400
Received: by wyb33 with SMTP id 33so1355382wyb.19
        for <linux-media@vger.kernel.org>; Sat, 19 Jun 2010 11:57:02 -0700 (PDT)
Date: Sat, 19 Jun 2010 20:58:17 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Pedro =?iso-8859-1?Q?C=F4rte-Real?= <pedro@pedrocr.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Trouble getting DVB-T working with Portuguese transmissions
Message-ID: <20100619185817.GA20032@linux-m68k.org>
References: <AANLkTiny9YXXT185VbNuw-z6aZDdIfS50UxFLERdlY-z@mail.gmail.com> <AANLkTinkDzTJfaFHx1bsGsdWlJnVGqa0n2VWdLvNBJRB@mail.gmail.com> <20100616205745.GA22103@linux-m68k.org> <AANLkTik-CVBuwVbXLlAQ1Vso4RlnAzSOzvkcIEhfR7uO@mail.gmail.com> <20100617200037.GA6530@linux-m68k.org> <AANLkTilA7_uw8memTQfyv5-YJD02HaroYmKJuSzePZBS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilA7_uw8memTQfyv5-YJD02HaroYmKJuSzePZBS@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 18, 2010 at 02:28:38PM +0100, Pedro Côrte-Real wrote:
> On Thu, Jun 17, 2010 at 9:00 PM, Richard Zidlicky <rz@linux-m68k.org> wrote:
> > berr is supposed to be the bit error rate. The values displayed here appear to be
> > bogus - then again I am not familiar with this particular driver so maybe just the
> > error reporting is bogus. The w_scan results also look pretty bad.
> >
> > Newest kernel is allways worth a try.
> 
> I have tried a git snapshot of Linus' 2.6.35 kernel. Is there another
> non-mainline tree I should try?
> 
> Would it help to get some kind of dvbsnoop log of this? I've tried
> doing "dvbsnoop  -s pidscan" and "dvbsnoop 0" but didn't get anything
> that seemed valid.

did you test the hardware with the evil OS? 

> Alternatively what is a well supported usb DVB-T tunner? I've also
> bought an Avermedia Volar HX and a Gigabyte 7200 which seem to have at
> best some half-assed out-of-tree drivers.

I am using 
 idVendor=2040, idProduct=5500
 WinTV MiniStick
 Manufacturer: Hauppauge Computer Works

works reasonably well, needs a patch to enable remote.

Richard
