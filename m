Return-path: <mchehab@pedra>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3930 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1AHNDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:03:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Daniel O'Connor" <darius@dons.net.au>
Subject: Re: Unable to build media_build (mk II)
Date: Sat, 8 Jan 2011 14:02:47 +0100
Cc: linux-media@vger.kernel.org
References: <155DD6D6-0766-4501-9B03-D5945460B040@dons.net.au> <201101081344.54075.hverkuil@xs4all.nl> <3D9DDC44-3862-4106-AC12-488A49CA95A8@dons.net.au>
In-Reply-To: <3D9DDC44-3862-4106-AC12-488A49CA95A8@dons.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101081402.47226.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 08, 2011 13:56:27 Daniel O'Connor wrote:
> 
> On 08/01/2011, at 23:14, Hans Verkuil wrote:
> >> Looking at some other consumers of that function it would appear the last argument (NULL in this case) is superfluous, however the file appears to be replaced each time I run build.sh so I can't update it.
> > 
> > Only run build.sh once. After that you can modify files and just run 'make'.
> > 
> > build.sh will indeed overwrite the drivers every time you run it so you should
> > that only if you want to get the latest source code.
> 
> Ahh, I see.
> 
> Any chance the README could be modified to say something about that?
> 
> Currently it doesn't mention build.sh at all - I had to google to find anything of use.
> 
> Perhaps also rename build.sh to setup.sh.

It was news to me as well :-)

Can someone with access rights to that git tree update the README and rename
the script?

Regards,

	Hans

> 
> Thanks :)
> 
> --
> Daniel O'Connor software and network engineer
> for Genesis Software - http://www.gsoft.com.au
> "The nice thing about standards is that there
> are so many of them to choose from."
>   -- Andrew Tanenbaum
> GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C
> 
> 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
