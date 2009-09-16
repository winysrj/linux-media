Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3239 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbZIPGad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 02:30:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: V4L/DVB API specifications at linux kernel
Date: Wed, 16 Sep 2009 08:30:23 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-doc@vger.kernel.org
References: <20090915162002.1c72c5b3@pedra.chehab.org> <200909152316.06025.hverkuil@xs4all.nl> <20090915211530.766a0d08@pedra.chehab.org>
In-Reply-To: <20090915211530.766a0d08@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909160830.23392.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 16 September 2009 02:15:30 Mauro Carvalho Chehab wrote:
> Em Tue, 15 Sep 2009 23:16:05 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Tuesday 15 September 2009 21:20:02 Mauro Carvalho Chehab wrote:
> > > Something that always bothered me is that the documentation inside the kernel
> > > for V4L/DVB were never properly updated, since people that write drivers in
> > > general don't bother to keep the docs updated there. After some time, we've
> > > removed V4L1 API from kernel (in text format, as far as I can remember), but
> > > never added V4L2 API. Also, there weren't there any dvb api specs.
> > > 
> > > As an effort to change it, I did a work during the last few weeks to port V4L2 API
> > > from DocBook v3.1 to DocBook XML v4.1.2. I also ported DVB specs from LaTex
> > > into DocBook XML v4.1.2. This way, the API docs are compatible with the DocBook version
> > > used in kernel (even eventually not having the same writing style as found there).
> > > 
> > > I tried to make the port as simple as possible, yet preserving the original
> > > text. So, for sure there are space for style reviews, especially at the dvb
> > > part, where the LaTex -> xml conversion were harder.
> > > 
> > > After having both ported, I've rearranged a few chapters and merged them
> > > both into just one DocBook book, to allow having some parts shared, like IR.
> > > 
> > > The final document were broken into 3 parts:
> > > I. Video for Linux Two API Specification
> > > 	(basically, the same contents found at V4L2 spec version 2.6.32, except for IR chapter)
> > > II. Linux DVB API
> > > 	(basically, the same contents found at DVB spec version 3)
> > > III. Other API's used by media infrastructure drivers
> > > 	(basically, the IR chapter taken from V4L2 spec)
> > > 
> > > The resulting html pages can be seen at: http://linuxtv.org/downloads/v4l_dvb_apis/
> > > 
> > > The Kernel patches with the Document are at:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=9444a960e4c7c49e055bb7fa66a0805c46317ba0
> > > http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-next.git;a=commit;h=664efd3215fdb17d5f3f70073af4a6b61d50a96c
> > > 
> > > Please review. If they're ok, I'm intending to submit them for addition at 2.6.32.
> > 
> > Good work!
> > 
> > Some suggestions:
> > 
> > Drop the 'Satellite Receivers' topic in the 'Tuners and Modulators' section.
> > That's now handled by the DVB API.
> 
> Done.
> 
> > Drop section 5 (V4L2 Driver Programming). Eventually we might move the
> > v4l2-framework.txt documentation there, but for now it can safely be removed.
> 
> Hmm.. in fact, driver.xml has some start, currently commented. IMHO, it is
> better to keep it there for a while, since something useful may be there.

I just looked at it, and there is nothing useful there. If we are going to
add a section like this, then it will be based around v4l2-framework.txt.

It might actually be a reasonable alternative to just convert that text file
into xml and have it replace driver.xml.

Regards,

	Hans

> > Do we really want section 7 (Changes) as part of the kernel documentation? I'm
> > not sure if it belongs there.
> 
> Maybe we can drop it in the future, but, as this is the first kernel version
> for the docs, it seems a good idea to commit it there, to preserve the
> documentation history. Also, maintaining it separate doesn't make sense. 
> 
> In the future, we may clean it up, for example converting it into revision
> marks, or, if we decide that no history is needed, just drop it and be happy.
> 
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
