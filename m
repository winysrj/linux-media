Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39544 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1I0CU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 22:20:56 -0400
Received: by bkbzt4 with SMTP id zt4so6425673bkb.19
        for <linux-media@vger.kernel.org>; Mon, 26 Sep 2011 19:20:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7FF0A0.7060004@gmail.com>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
Date: Mon, 26 Sep 2011 22:20:55 -0400
Message-ID: <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
Subject: Re: Problems cloning the git repostories
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 25, 2011 at 11:25 PM, Mauro Carvalho Chehab
<maurochehab@gmail.com> wrote:
> I fail to see any trial from your side to send the patches upstream:
> no pull requests and no patches for this driver were _ever_ sent to
> the ML.

You and I have discussed this issue multiple times with these drivers,
including the drx-j (which is the basis for the 80e device in
question).  All the code is publicly available, and I in fact invited
you personally to pull whatever you want (as a policy we don't publish
public trees that have outstanding licensing issues).

Look how long it took to get xc4000 upstream.  Look how long it took
drx-d to get upstream.  Those trees sat there for *years* with your
full knowledge of their existence and that the only reason they
weren't merged was because of codingstyle issues.

Oh, and I did spend a bunch of hours doing cleanup work on the as102
driver, and it was still not good enough.  I decided it wasn't worth
the additional time.  That tree has only been rotting for 19 months.

> I can only guess that maybe submitting it upstream were not
> part of your contract with the vendor.

I don't even know what this means.  Commercial customers who I've done
work for almost never are willing to pay for me to merge code
upstream.  And yet code does get upstream.  Why?  Because I do it in
my free time as a courtesy to the community.

Probably also worth noting that the project in question - the 80e -
was not done for any customer.  I just did the work because I wanted
to see the device supported under Linux.

> Coding Style fixes are generally trivial, and they can be done very quickly
> with some scripting. I took only a few hours to convert drx-d and drx-k
> to the Linux Coding Style, on my spare time. The scripts I wrote for that
> are together with the commits (they're generally a few lines perl scripting
> doing some replacements). I usually do this with other drivers, when people
> submit me them with those troubles and I have some time, and never asked
> or earned a single penny for doing that.

Hey, feel free to grab the drx-j driver then.  This is like the fourth
time I'm invited you to pull the sources and do such a cleanup.  And
like I said above, I don't earn any money for such cleanups either.  I
just believe it's a colossal waste of my time that would be better
spent doing real driver development.

> Also, as I've told you several times before, code with broken coding styles
> can be submitted as-is, without any changes to drivers/staging, where they're
> fixed by kernel newbies with more time to work on that.

Last I checked you can't put demod or tuners drivers into staging
because they are a dependency of the bridge driver.  I guess maybe you
can accomplish that if you litter the bridge driver source and
makefiles with #ifdef lines.  If that situation has changed, then
great.

> So, please don't use weak arguments like that as an excuse for you to not
> submit your drivers.

Suggesting that the developers who are trying to give you working code
at zero cost is a pretty crappy way to treat them.

>> Want to see more device support upstream?  Optimize the process to
>> make it easy for the people who know the hardware and how to write the
>> drivers to get code upstream, and leave it to the "janitors" to work
>> out the codingstyle issues.
>
> The process you've just described exists already since Sept, 2008.
> It is called:
>        /drivers/staging
>
> In summary, if you don't have a couple hours to make your driver to
> match Kernel Coding Style, just send it as is to /drivers/staging, c/c
> me and Greg KH, and that's it.

PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-80e/
PULL http://kernellabs.com/hg/~dheitmueller/v4l-dvb-as102-2/

Have fun.

The harder you make it to get code upstream, the more developers who
will just say "to hell with this".  And *that* is why there are
thousands of lines of working drivers which various developers have in
out-of-tree drivers.

You can sit in denial that there is a fundamental problem with the
management of this project and blame the developers for being lazy, or
you can take some concrete action to get the code merged upstream.

Your call.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
