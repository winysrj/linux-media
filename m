Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44460 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1JGSIN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2011 14:08:13 -0400
Received: by wyg34 with SMTP id 34so4145095wyg.19
        for <linux-media@vger.kernel.org>; Fri, 07 Oct 2011 11:08:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110061423.22064.hverkuil@xs4all.nl>
References: <201110061423.22064.hverkuil@xs4all.nl>
Date: Fri, 7 Oct 2011 23:38:11 +0530
Message-ID: <CAHFNz9KPXY-z+zq0iSE3O66GaDj-2MA8vWO21KLbjN9tw6RZ-w@mail.gmail.com>
Subject: Re: [RFC] Merge v4l-utils. dvb-apps and mediactl to media-utils.git
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 6, 2011 at 5:53 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Currently we have three repositories containing libraries and utilities that
> are relevant to the media drivers:
>
> dvb-apps (http://linuxtv.org/hg/dvb-apps/)
> v4l-utils (http://git.linuxtv.org/v4l-utils.git)
> media-ctl (git://git.ideasonboard.org/media-ctl.git)
>
> It makes no sense to me to have three separate repositories, one still using
> mercurial and one that isn't even on linuxtv.org.

We had a discussion earlier on the same subject wrt dvb-apps and the
decision at that time was against a merge. That decision still holds.

Regards,
Manu
