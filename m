Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37419 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0EJK4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 06:56:40 -0400
Received: by bwz19 with SMTP id 19so1665434bwz.21
        for <linux-media@vger.kernel.org>; Mon, 10 May 2010 03:56:38 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Tim Coote <tim+vger.kernel.org@coote.org>
Subject: Re: setting up a tevii s660
Date: Mon, 10 May 2010 13:56:43 +0300
Cc: linux-media@vger.kernel.org
References: <E23F27D7-CF5B-4F6B-9656-EB63E7005BD0@coote.org> <201005092146.23620.liplianin@me.by> <CF4FB529-8D84-48B6-98DC-BD20BB2A4F60@coote.org>
In-Reply-To: <CF4FB529-8D84-48B6-98DC-BD20BB2A4F60@coote.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201005101356.44189.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10 мая 2010 00:29:13 Tim Coote wrote:
> Thanks, Igor. I was using that set of drivers (if I understood the
> Babelfish translation.)
>
> My issue was that my hardware was broken (I was using a VMWare VM that
> didn't emulate usb properly). It's always hard to work out what's
> broken when you load up some new package and it doesn't work.  I'd
> confirmed that the s660 worked from windows, but I had to build a
> windows vm to demonstrate that it was VMWare that was broken.
> Meanwhile, I kept stumbling across what seemed to be similar breakages
> to what I was seeing.
>
> I don't know how feasible it would be, but when I used to write device
> drivers, I'd pull together simple programs to test that the hardware
> was working as I'd expect as I spent so much time debugging changing
> hardware designs :-(
>
> I would say that the tevii drivers have both new code compared to the
> tip of the driver that you manage, and also seem to be missing some
> code.
So called "TeVii drivers" is simply a snapshot from linuxtv, so OK, they are useable.

>
> thanks again for your help.  Now all I've got to do is get mythtv to
> work...
>
> Tim
>
> On 9 May 2010, at 19:46, Igor M. Liplianin wrote:
> > On 6 мая 2010 02:07:38 Tim Coote wrote:
> >> [snip]
> >
> > Hi!
> > Read this:
> > http://forum.free-x.de/wbb/index.php?page=Thread&threadID=601&pageNo=6
> > Useful to translate from Russian:
> > http://babelfish.yahoo.com/translate_txt
> > Best regards
> > --
> > Igor M. Liplianin
> > Microsoft Windows Free Zone - Linux used for all Computing Tasks
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Tim Coote
> tim@coote.org
> +44 (0)7866 479 760

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
