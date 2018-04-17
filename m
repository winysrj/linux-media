Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34692 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbeDQGRh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 02:17:37 -0400
Received: by mail-io0-f179.google.com with SMTP id d6so21025494iog.1
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 23:17:37 -0700 (PDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com. [209.85.214.46])
        by smtp.gmail.com with ESMTPSA id t186-v6sm5571064ita.32.2018.04.16.23.17.36
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Apr 2018 23:17:36 -0700 (PDT)
Received: by mail-it0-f46.google.com with SMTP id f6-v6so14496080ita.2
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 23:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <CAPBb6MVLpV6gbUWBnQpYiNoWmjqdhYOhicrsetT0S5p_w28HDw@mail.gmail.com>
 <95c7bf3a-06f0-46d6-d51f-47e851180681@xs4all.nl>
In-Reply-To: <95c7bf3a-06f0-46d6-d51f-47e851180681@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 17 Apr 2018 06:17:25 +0000
Message-ID: <CAPBb6MVg+3JHZC1F5qz2=ZiScnHpVD7kvouYYWOEFN3CaqFPeQ@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 00/29] Request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 17, 2018 at 3:12 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 04/17/2018 06:33 AM, Alexandre Courbot wrote:
> > On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >
> >> Hi all,
> >
> >> This is a cleaned up version of the v10 series (never posted to
> >> the list since it was messy).
> >
> > Hi Hans,
> >
> > It took me a while to test and review this, but finally have been able
to
> > do it.
> >
> > First the result of the test: I have tried porting my dummy vim2m test
> > program
> > (https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42 for
> > reference),
> > and am getting a hang when trying to queue the second OUTPUT buffer
(right
> > after
> > queuing the first request). If I move the calls the VIDIOC_STREAMON
after
> > the
> > requests are queued, the hang seems to happen at that moment. Probably a
> > deadlock, haven't looked in detail yet.
> >
> > I have a few other comments, will follow up per-patch.
> >

> I had a similar/same (?) report about this from Paul:

> https://www.mail-archive.com/linux-media@vger.kernel.org/msg129177.html

I saw this and tried to move the call to STREAMON to after the requests are
queued in my example program, but it then hanged there. So there is
probably something more intricate taking place.
