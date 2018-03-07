Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55951 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751241AbeCGS1z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Mar 2018 13:27:55 -0500
Date: Wed, 7 Mar 2018 20:27:50 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Bjorn Pagen <bjornpagen@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: v4l-utils fails to build against musl libc (with patch)
Message-ID: <20180307182749.7xgbtummngj4mxhx@tarshish>
References: <1520442688.19980.1.camel@gmail.com>
 <CAARz7_gSDbpeNfw+etEJCDXGG6iRU9TPXSm9E7VLMjCg9S4ZSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAARz7_gSDbpeNfw+etEJCDXGG6iRU9TPXSm9E7VLMjCg9S4ZSQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bjorn,

On Wed, Mar 07, 2018 at 12:14:05PM -0500, Bjorn Pagen wrote:
> Here's the link again and it's tinyurl, since the link seems to be
> borked because of line wraparounds:
> 
> https://git.alpinelinux.org/cgit/aports/tree/community/v4l-utils/0001-ir-ctl-fixes-for-musl-compile.patch
> https://tinyurl.com/y7gr6eju

Peter Seiderer posted a fix for that to the list a few days ago.

  https://www.mail-archive.com/linux-media@vger.kernel.org/msg127134.html

baruch

> On Wed, Mar 7, 2018 at 12:11 PM,  <bjornpagen@gmail.com> wrote:
> > Hey all,
> >
> > v4l-utils currently fails to build against musl libc, since musl, and
> > POSIX, both do not define TEMP_FAILURE_RETRY() or strndupa().
> >
> > This can be fixed with a small patch from https://git.alpinelinux.org/c
> > git/aports/tree/community/v4l-utils/0001-ir-ctl-fixes-for-musl-compile.
> > patch.
> >
> > Please email me back with any questions or concerns about the patch or
> > musl.
> >
> > Thanks,
> > Bjorn Pagen

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
