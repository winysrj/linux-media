Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34881 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1JSN51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Oct 2011 09:57:27 -0400
Received: by bkbzt19 with SMTP id zt19so2148064bkb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Oct 2011 06:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E9EC441.4090400@gmail.com>
References: <4E7F1FB5.5030803@gmail.com>
	<CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com>
	<4E7FF0A0.7060004@gmail.com>
	<CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com>
	<20110927094409.7a5fcd5a@stein>
	<20110927174307.GD24197@suse.de>
	<20110927213300.6893677a@stein>
	<4E99F2F6.9000307@poczta.onet.pl>
	<20111017223136.GA20939@kroah.com>
	<4E9EC441.4090400@gmail.com>
Date: Wed, 19 Oct 2011 09:57:26 -0400
Message-ID: <CAGoCfizK7ZqrKuU+wO6UzsvGGO3w7LESGLpg9ijr1FUHgjr++w@mail.gmail.com>
Subject: Re: Staging questions: WAS Re: [PATCH 0/7] Staging submission: PCTV
 74e drivers and some cleanup
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Patrick Dickey <pdickeybeta@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Patrick,

On Wed, Oct 19, 2011 at 8:36 AM, Patrick Dickey <pdickeybeta@gmail.com> wrote:
> I'm posting this question under this thread because the subject pertains
> to the question (in that I'm asking about staging and about the PCTV 80e
> drivers).

You should definitely be looking at the "as102" thread that is
currently going on this mailing list.  Piotr is actually going through
the same process as you are (he is working on upstreaming the as102
driver from a kernellabs.com tree).  He made some pretty common
mistakes (all perfectly understandable), and your reading the thread
might help you avoid them (and having to redo your patch series).

> I started cleaning up the drx39xx* drivers for the PCTV-80e and have
> them in a github repository. Ultimately I want to send a pull request,
> so other people can finish the cleaning (as I'm not comfortable with
> pulling out the #ifdef statements myself).

You should definitely ask Mauro how he expects to do a staging driver
for a demodulator before you do any further work.  The staging tree
works well for bridge drivers, but demod drivers such as the drx
require code in the bridge driver (the em28xx in this case), so it's
not clear how you would do staging for a product where the bridge
driver isn't in staging as well.  The answer to that question will
likely guide you in how to get the driver into staging.

If you have specific questions regarding anything you see in the
driver, let me know.  I don't have much time nowadays but will find
the time if you ask concise questions.

Good luck.  It will be great to finally see this merged upstream.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
