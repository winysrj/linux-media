Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KhPtp-0005bd-KB
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 16:26:58 +0200
Received: by ug-out-1314.google.com with SMTP id 39so3558433ugf.16
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 07:26:54 -0700 (PDT)
Message-ID: <412bdbff0809210726i7118f62et1627e22426771656@mail.gmail.com>
Date: Sun, 21 Sep 2008 10:26:54 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Jonathan Coles" <jcoles0727@rogers.com>
In-Reply-To: <48D6329C.1010309@rogers.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48D059AE.1060307@rogers.com>
	<bb72339d0809161837w58ce1256g519306a029e36294@mail.gmail.com>
	<48D4DE00.90005@rogers.com> <48D510E8.7080900@linuxtv.org>
	<48D6329C.1010309@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Questions on v4l-dvb driver instructions
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, Sep 21, 2008 at 7:40 AM, Jonathan Coles <jcoles0727@rogers.com> wrote:
> I already have the man page for hg and hgrc. But, admittedly, I had only
> looked the one for hg.
>
> Assuming the problem was proxy related, as with wget, I added a
> [http_proxy] section, with "no=linuxtv.org". That worked! Unfortunately,
> "no=*" does not work, so every Mercurial host I ever want to access will
> have to be added to the file.
>
> I don't understand why I would use a proxy for downloads. If this is on
> one's own machine, what security is gained?
>
> Overall, the Mercurial issues are just an unnecessary complication, and
> my real problem with v4l-dvb for the HVR-950 is probably something to do
> with loading firmware or kernel modules. Linux has come a long way in
> the five years or so that I have been using it. But, some things, like
> using an off-the-shelf USB device, can still prove impossibly complex
> for those of us who are not hard-core computer geeks.

That is indeed strange, as Ubuntu does not ship with any proxy support
enabled by default.

The HVR-950 works in Ubuntu 8.04 (that's what I wrote it under) but be
forewarned that Ubuntu screwed up their kernel build process in 8.04
so that the analog audio driver doesn't build from source.  If you're
planning on using the device for ATSC then you are fine, but if you're
doing analog audio then you would need to rebuild the kernel from
source (which is a real pain).

I can certainly appreciate your frustration regarding this stuff
"working off the shelf".  It was that exact frustration with the
HVR-950 support that got me involved in the project in the first
place.  If it's any consolation, since support was merged into the
kernel it now works in the stock Fedora 9 and it will work in the
out-of-the-box Ubuntu 8.10 when it comes out.  All you will have to do
is stick the firmware file into /lib/firmware.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
