Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:53002 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752841AbeDRCHG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 22:07:06 -0400
Received: by mail-it0-f43.google.com with SMTP id f6-v6so592642ita.2
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 19:07:06 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com. [209.85.223.170])
        by smtp.gmail.com with ESMTPSA id g189-v6sm88307ioe.0.2018.04.17.19.07.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Apr 2018 19:07:04 -0700 (PDT)
Received: by mail-io0-f170.google.com with SMTP id s14-v6so584835ioc.0
        for <linux-media@vger.kernel.org>; Tue, 17 Apr 2018 19:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
 <95c7bf3a-06f0-46d6-d51f-47e851180681@xs4all.nl> <CAPBb6MVg+3JHZC1F5qz2=ZiScnHpVD7kvouYYWOEFN3CaqFPeQ@mail.gmail.com>
 <d9fa6ca0e79672dc523e1c56ba19ec07c5d5259d.camel@bootlin.com>
In-Reply-To: <d9fa6ca0e79672dc523e1c56ba19ec07c5d5259d.camel@bootlin.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 18 Apr 2018 02:06:53 +0000
Message-ID: <CAPBb6MW9f6MPxMj9W8TMfqdhEMYZPX85w3y159sL5kQq5jjsBA@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 00/29] Request API
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 17, 2018 at 8:41 PM Paul Kocialkowski <
paul.kocialkowski@bootlin.com> wrote:

> Hi,

> On Tue, 2018-04-17 at 06:17 +0000, Alexandre Courbot wrote:
> > On Tue, Apr 17, 2018 at 3:12 PM Hans Verkuil <hverkuil@xs4all.nl>
> > wrote:
> >
> > > On 04/17/2018 06:33 AM, Alexandre Courbot wrote:
> > > > On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl>
> > > > wrote:
> > > >
> > > > > From: Hans Verkuil <hans.verkuil@cisco.com>
> > > > > Hi all,
> > > > > This is a cleaned up version of the v10 series (never posted to
> > > > > the list since it was messy).
> > > >
> > > > Hi Hans,
> > > >
> > > > It took me a while to test and review this, but finally have been
> > > > able
> >
> > to
> > > > do it.
> > > >
> > > > First the result of the test: I have tried porting my dummy vim2m
> > > > test
> > > > program
> > > > (https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42
> > > > for
> > > > reference),
> > > > and am getting a hang when trying to queue the second OUTPUT
> > > > buffer
> >
> > (right
> > > > after
> > > > queuing the first request). If I move the calls the
> > > > VIDIOC_STREAMON
> >
> > after
> > > > the
> > > > requests are queued, the hang seems to happen at that moment.
> > > > Probably a
> > > > deadlock, haven't looked in detail yet.
> > > >
> > > > I have a few other comments, will follow up per-patch.
> > > >
> > > I had a similar/same (?) report about this from Paul:
> > > https://www.mail-archive.com/linux-media@vger.kernel.org/msg129177.h
> > > tml
> >
> > I saw this and tried to move the call to STREAMON to after the
> > requests are queued in my example program, but it then hanged there.
> > So there is probably something more intricate taking place.

> I figured out the issue (but forgot to report back to the list): Hans'
> version of the request API doesn't set the POLLIN bit but POLLPRI
> instead, so you need to select for expect_fds instead of read_fds in the
> select call. That's pretty much all there is to it.

I am not using select() but poll() in my test program (see the gist link
above) and have set POLLPRI as the event to poll for. I may be missing
something but this looks correct to me?
