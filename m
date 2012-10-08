Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39947 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab2JHHjm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 03:39:42 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so3515824wgb.1
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 00:39:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121006121908.33709692@infradead.org>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
	<1348652877-25816-2-git-send-email-javier.martin@vista-silicon.com>
	<20120926104007.4de17d19@lwn.net>
	<CACKLOr2+cWAgKspq+OKTQOvKcBGDSDZg05tx0mqNV1n=38Lr_g@mail.gmail.com>
	<20121006121908.33709692@infradead.org>
Date: Mon, 8 Oct 2012 09:39:41 +0200
Message-ID: <CACKLOr2e=OU2Z0QJmAuXjscqSAFq88D=oM50zwJ08YAWmMpS2g@mail.gmail.com>
Subject: Re: [PATCH 1/5] media: ov7670: add support for ov7675.
From: javier Martin <javier.martin@vista-silicon.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 6 October 2012 17:19, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> Em Thu, 27 Sep 2012 08:58:33 +0200
> javier Martin <javier.martin@vista-silicon.com> escreveu:
>
>> Hi Jonathan,
>> thank you for your time.
>>
>> On 26 September 2012 18:40, Jonathan Corbet <corbet@lwn.net> wrote:
>> > This is going to have to be quick, sorry...
>> >
>> > On Wed, 26 Sep 2012 11:47:53 +0200
>> > Javier Martin <javier.martin@vista-silicon.com> wrote:
>> >
>> >> +static struct ov7670_win_size ov7670_win_sizes[2][4] = {
>> >> +     /* ov7670 */
>> >
>> > I must confess I don't like this; now we've got constants in an array that
>> > was automatically sized before and ov7670_win_sizes[info->model]
>> > everywhere.  I'd suggest a separate array for each device and an
>> > ov7670_get_wsizes(model) function.
>> >
>> >> +             /* CIF - WARNING: not tested for ov7675 */
>> >> +             {
>> >
>> > ...and this is part of why I don't like it.  My experience with this
>> > particular sensor says that, if it's not tested, it hasn't yet seen the
>> > magic-number tweaking required to actually make it work.  Please don't
>> > claim to support formats that you don't know actually work, or I'll get
>> > stuck with the bug reports :)
>>
>> Your concern makes a lot of sense. In fact, that was one of my doubts
>> whether to 'support' not tested formats or not.
>>
>> Let me fix that in a new version.
>
> Hi Javier,
>
> I'm assuming that you'll be sending a new version of this entire changeset.
> So, I'll just mark this entire series as changes_requested.

Hi Mauro,

v2 of this changeset has already been sent with Jon Corbet's ack:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg52767.html

https://patchwork.kernel.org/patch/1515001/
https://patchwork.kernel.org/patch/1515021/
https://patchwork.kernel.org/patch/1515011/
https://patchwork.kernel.org/patch/1515031/
https://patchwork.kernel.org/patch/1515041/

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
