Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4240 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935285Ab0KQTze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:55:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Anca Emanuel <anca.emanuel@gmail.com>
Subject: Re: [cron job] v4l-dvb daily build: WARNINGS
Date: Wed, 17 Nov 2010 20:55:18 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201011171827.oAHIROhd086781@smtp-vbr18.xs4all.nl> <AANLkTinb+h5FRodn-upP3PwNhtORskC=y7bcOeafbMvS@mail.gmail.com>
In-Reply-To: <AANLkTinb+h5FRodn-upP3PwNhtORskC=y7bcOeafbMvS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011172055.18725.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, November 17, 2010 19:51:22 Anca Emanuel wrote:
> On Wed, Nov 17, 2010 at 8:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > This message is generated daily by a cron job that builds v4l-dvb for
> > the kernels and architectures in the list below.
> >
> > Results of the daily build of v4l-dvb:
> >
> > date:        Wed Nov 17 19:00:17 CET 2010
> > path:        http://www.linuxtv.org/hg/v4l-dvb
> > changeset:   15167:abd3aac6644e
> > git master:       3e6dce76d99b328716b43929b9195adfee1de00c
> > git media-master: a348e9110ddb5d494e060d989b35dd1f35359d58
> > gcc version:      i686-linux-gcc (GCC) 4.5.1
> > host hardware:    x86_64
> > host os:          2.6.32.5
> >
> > linux-git-armv5: WARNINGS
> > linux-git-armv5-davinci: WARNINGS
> > linux-git-armv5-ixp: WARNINGS
> > linux-git-armv5-omap2: WARNINGS
> > linux-git-i686: WARNINGS
> > linux-git-m32r: WARNINGS
> > linux-git-mips: WARNINGS
> > linux-git-powerpc64: WARNINGS
> > linux-git-x86_64: WARNINGS
> > spec-git: OK
> > sparse: ERRORS
> >
> > Detailed results are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Wednesday.log
> >
> > Full logs are available here:
> >
> > http://www.xs4all.nl/~hverkuil/logs/Wednesday.tar.bz2
> >
> > The V4L-DVB specification from this daily build is here:
> >
> > http://www.xs4all.nl/~hverkuil/spec/media.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Is somebody take care of this ?

In what respect? I maintain the daily build, although I am well aware that
it needs more attention than I can give. The intention was to provide full
coverage of all drivers, but I know some boards are currently not covered.

I no longer have time to fix warnings/errors reported by the build, so if
someone would do that, then that would be great.

BTW, the build was still doing the 2.6.37 branch. I've just switched it to
the for_v2.6.38 branch. So tomorrow it will build from there.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
