Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:41054 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab0COWxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 18:53:11 -0400
Received: by gwaa12 with SMTP id a12so77972gwa.19
        for <linux-media@vger.kernel.org>; Mon, 15 Mar 2010 15:53:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4B8FF80C.7050009@andago.com>
References: <4B8E3C69.2090800@andago.com> <4B8FF80C.7050009@andago.com>
Date: Mon, 15 Mar 2010 19:53:09 -0300
Message-ID: <9c4b1d601003151553h42c8c74eoaa2cbceaefa38818@mail.gmail.com>
Subject: Re: Ubuntu and AverMedia DVD EZMaker USB Gold
From: Adrian Pardini <pardo.bsso@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Jorge Cabrera <jorge.cabrera@andago.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/2010, Jorge Cabrera <jorge.cabrera@andago.com> wrote:
> Hello again,
>
> I was wrong here, the driver works, the device works great but what's
> going on is that it uses the tuner as the default input, when I run
> mplayer with input=1 (composite video) or input=2 (s-video) it works good:
>
> mplayer tv:// -tv input=1:device=/dev/video0
>
> But this isn't good enough because cheese and camorama and flash use the
> default input. How can I set up default input to composite video or
> s-video? Should I add something to the options that the Avermedia kernel
> module uses?

Try using the v4lctl command. Something like

v4lctl setinput Composite1

will do. You can replace "Composite1" with other names like Television
etc. The manpage has more information.


-- 
Adrian.
http://elesquinazotango.com.ar
http://www.noalcodigodescioli.blogspot.com/
