Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:49634 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbbFXKrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:47:37 -0400
Date: Wed, 24 Jun 2015 07:47:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Kim, Heung Jun" <riverful@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: userspace media util repository
Message-ID: <20150624074731.46754ba2@recife.lan>
In-Reply-To: <CAG0J7uTH=-UAOBZuHq8aH9apfv5QK_ESMgJUeAj1JdmDG5nhQg@mail.gmail.com>
References: <etPan.558a3be7.76b88e23.104c@rivermac.local>
	<CAG0J7uQYcBr0k77LW3rT6UZtWEGcxkV8+MnwLeCKPKfVgGhbmQ@mail.gmail.com>
	<Pine.LNX.4.64.1506240736250.31534@axis700.grange>
	<CAG0J7uTH=-UAOBZuHq8aH9apfv5QK_ESMgJUeAj1JdmDG5nhQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 24 Jun 2015 14:58:12 +0900
"Kim, Heung Jun" <riverful@gmail.com> escreveu:

> Thank you for reply, Guennadi.
> 
> I'm not sure of it. In my memory it was capable of making "ps" file shows
> the relationship between entities of media devices. And, in my quick glance
> I can not find that codes in it (yet).
> 
> Am I right that such user application working like this exists? In fact, my
> memory can be wrong.
> 
> Any comments are welcome and very helpful, and I'd appreciated in advance.
> 
> ps. Sorry for some corrupted characters in my previous mail by unsetting
> mail client yet.


ps doesn't show the media controller entities. The tool that does that
is media-ctl. This tool is there at v4l-utils package.

Regards,
Mauro

> 
> 
> 2015-06-24 14:37 GMT+09:00 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> 
> > Do you mean this?
> >
> > http://git.linuxtv.org/cgit.cgi/v4l-utils.git/
> >
> > Regards
> > Guennadi
> >
> > On Wed, 24 Jun 2015, Kim, Heung Jun wrote:
> >
> > > Hi all,
> > >
> > > Iâ  m looking for official repository for user space media utils. For
> > testing
> > > media device status on target I was about to use it, but I couldnâ  t
> > find it
> > > now on linuxtv.org site which Iâ  ve seen about some years ago.
> > >
> > > Would anyone please let me inform where it is?
> > >
> > > Regards,
> > > HeungJun (Jeremy) Kim
> > >
> >
