Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59586 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab2I0G6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 02:58:35 -0400
Received: by weyt9 with SMTP id t9so426053wey.19
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 23:58:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120926104007.4de17d19@lwn.net>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-2-git-send-email-javier.martin@vista-silicon.com>
	<20120926104007.4de17d19@lwn.net>
Date: Thu, 27 Sep 2012 08:58:33 +0200
Message-ID: <CACKLOr2+cWAgKspq+OKTQOvKcBGDSDZg05tx0mqNV1n=38Lr_g@mail.gmail.com>
Subject: Re: [PATCH 1/5] media: ov7670: add support for ov7675.
From: javier Martin <javier.martin@vista-silicon.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,
thank you for your time.

On 26 September 2012 18:40, Jonathan Corbet <corbet@lwn.net> wrote:
> This is going to have to be quick, sorry...
>
> On Wed, 26 Sep 2012 11:47:53 +0200
> Javier Martin <javier.martin@vista-silicon.com> wrote:
>
>> +static struct ov7670_win_size ov7670_win_sizes[2][4] = {
>> +     /* ov7670 */
>
> I must confess I don't like this; now we've got constants in an array that
> was automatically sized before and ov7670_win_sizes[info->model]
> everywhere.  I'd suggest a separate array for each device and an
> ov7670_get_wsizes(model) function.
>
>> +             /* CIF - WARNING: not tested for ov7675 */
>> +             {
>
> ...and this is part of why I don't like it.  My experience with this
> particular sensor says that, if it's not tested, it hasn't yet seen the
> magic-number tweaking required to actually make it work.  Please don't
> claim to support formats that you don't know actually work, or I'll get
> stuck with the bug reports :)

Your concern makes a lot of sense. In fact, that was one of my doubts
whether to 'support' not tested formats or not.

Let me fix that in a new version.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
