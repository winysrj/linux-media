Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51302 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1JHMmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Oct 2011 08:42:31 -0400
Received: by wwf22 with SMTP id 22so7128942wwf.1
        for <linux-media@vger.kernel.org>; Sat, 08 Oct 2011 05:42:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E903E3B.8050408@redhat.com>
References: <201110061423.22064.hverkuil@xs4all.nl>
	<CAHFNz9KPXY-z+zq0iSE3O66GaDj-2MA8vWO21KLbjN9tw6RZ-w@mail.gmail.com>
	<4E903E3B.8050408@redhat.com>
Date: Sat, 8 Oct 2011 18:12:29 +0530
Message-ID: <CAHFNz9+VMw-_ussEDRqCKjqwMsJ4zJ0_4JO14sgz9cQ=A7cUoA@mail.gmail.com>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 8, 2011 at 5:42 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 07-10-2011 15:08, Manu Abraham escreveu:
>>
>> On Thu, Oct 6, 2011 at 5:53 PM, Hans Verkuil<hverkuil@xs4all.nl>  wrote:
>>>
>>> Currently we have three repositories containing libraries and utilities
>>> that
>>> are relevant to the media drivers:
>>>
>>> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
>>> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
>>> media-ctl (git://git.ideasonboard.org/media-ctl.git)
>>>
>>> It makes no sense to me to have three separate repositories, one still
>>> using
>>> mercurial and one that isn't even on linuxtv.org.
>>
>> We had a discussion earlier on the same subject wrt dvb-apps and the
>> decision at that time was against a merge. That decision still holds.
>
> Yes, years ago when v4l-utils tree were created. Since them, there was
> several
> major releases of it, and not a single release of dvb-apps, with, btw, still
> lacks proper support for DVB APIv5.
>
> So, why not discuss it again?

- dvb-apps is a repository consisting of simple stand-alone utils,
basically meant for raw tests alone.
(these tiny test apps don't have any external dependencies, so there
exists no issues regarding packaging. for such a development model, a
merge with a repository having other dependencies, this merge concept
doesn't work well)
In fact your own example repository with --disable this --enable that
implies that, one needs to download the whole thing, altogether. I
don't need to download things that's irrelevant to me.

- a repository and how it works depends on the people working with it.
(It depends on the comfortability of the people working
with/maintaining it. It was found that the existing model works well
and needs no change)

- just simply making a release number, doesn't make a new release.
(That said, a release is very near)

- I don't see any significant contributions either from Hans V, the
proposer for the merger of dvb-apps, or from you.

- API v5 is severely broken in many senses and unusable in the way it
is supposed to be used, it is still worked around using the v3 API
(I will address this broken issue and try to have a fix in another mail)
