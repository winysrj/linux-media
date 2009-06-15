Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:43538 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZFOAWc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2009 20:22:32 -0400
Received: by bwz9 with SMTP id 9so3038201bwz.37
        for <linux-media@vger.kernel.org>; Sun, 14 Jun 2009 17:22:33 -0700 (PDT)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Simon Kenyon <simon@koala.ie>
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
Date: Mon, 15 Jun 2009 03:24:47 +0300
Cc: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <200906121205.08345.liplianin@me.by> <4A357E65.3060404@koala.ie>
In-Reply-To: <4A357E65.3060404@koala.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906150324.47856.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15 June 2009 01:49:09 Simon Kenyon wrote:
> Igor M. Liplianin wrote:
> > On 6 June 2009 23:37:47 Simon Kenyon wrote:
> >> Igor M. Liplianin wrote:
> >>> On 5 June 2009 21:41:46 Simon Kenyon wrote:
> >>>> Simon Kenyon wrote:
> >>>>> Simon Kenyon wrote:
> >>>>>> the picture seems to be breaking up badly
> >>>>>> will revert to my version and see if that fixes it
> >>>>>
> >>>>> [sorry for the delay. i was away on business]
> >>>>>
> >>>>> i've checked and your original code, modified to compile and
> >>>>> including my changes to control the LNB works very well; the patch
> >>>>> you posted does not. i have swapped between the two and rebooted
> >>>>> several times to make sure.
> >>>>>
> >>>>> i will do a diff and see what the differences are
> >>>>>
> >>>>> regards
> >>>>> --
> >>>>> simon
> >>>>
> >>>> the main changes seem to be a reworking of the interrupt handling and
> >>>> some i2c changes
> >>>> --
> >>>> simon
> >>>
> >>> How fast is your system?
> >>
> >> reasonably fast
> >> it is a dual core AMD64 X2 running at 3.1GHz
> >
> > Main change is to move demuxing from interrupt to work handler.
> > So I prepaired another patch, with separate work queue.
> > May be you find some time to test.
> >
> > I wonder CPU usage and interrupts count(cat /proc/interrupts) while
> > viewing DVB. I guess your card generates a lot of unnecessary(unknown ?)
> > irq's.
> >
> > Another idea is to increase dma buffer.
>
> i've tested that now
> sorry for the delay - at a family wedding
>
> anyway, that seems to work fine. will st some more, but the first
> results (with kaffeine) seem good.
>
> i did a complete scan and then tried about 20 different channels. they
> all seemed to work fine.
>
> thanks
> --
> simon
Good news.
Thank you for testing.


Igor
