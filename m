Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36484 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbcAZMf2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 07:35:28 -0500
Received: by mail-wm0-f41.google.com with SMTP id l65so102144649wmf.1
        for <linux-media@vger.kernel.org>; Tue, 26 Jan 2016 04:35:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <m3si1kioa9.fsf@t19.piap.pl>
References: <1451183213-2733-1-git-send-email-ezequiel@vanguardiasur.com.ar>
	<569CE27F.6090702@xs4all.nl>
	<CAAEAJfCs1fipSadLj8WyxiJd9g7MCJj1KX5UdAPx1hPt16t0VA@mail.gmail.com>
	<m31t96j8u4.fsf@t19.piap.pl>
	<CAAEAJfBM_vVBVRd3P0kJ1QLzk-M==L=x6CS0ggXgRX=7K_aK_A@mail.gmail.com>
	<m3si1kioa9.fsf@t19.piap.pl>
Date: Tue, 26 Jan 2016 09:35:27 -0300
Message-ID: <CAAEAJfC_Sa_6opADoz0Ab8NrmhX+cjNmSK_Nw_Ne9nk-ROaj0Q@mail.gmail.com>
Subject: Re: [PATCH] media: Support Intersil/Techwell TW686x-based video
 capture cards
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26 January 2016 at 08:16, Krzysztof Hałasa <khalasa@piap.pl> wrote:
> Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> writes:
>
>> Well, I plan to add SG mode as soon as this driver is merged, so hopefully you
>> won't have to use an out of tree driver anymore.
>
> So why don't you want to do it the normal way, i.e., add your specific
> changes on top of my driver?
>

As far as I can see, you sent a driver back in July:

https://patchwork.linuxtv.org/patch/30448/

I reviewed the driver as soon as it was sent, and planned to submit
changes to support my setup once your driver was merged, but that
never happened.

Since you never submitted a v2, I sincerely thought that after six
months you had lost the interest.
There is no "your" driver vs. "my" driver, it's the same driver, as
the copyright note explains.

> This way you don't have to add SG mode. It's already there. Also, this
> means I (and others) don't have to hope. And, your changes can be much
> better examined, bisected etc.
>
> For now, there is no in-tree driver, all versions are out of tree.
>
> At the moment, from my POV it all looks this way:
> - I have written a driver and posted it for inclusion
> - it works on my systems, complies with the LK, V4L standards etc.,
>   though it probably still needs some small changes
> - you took it, (I guess) added the needed changes (and others), removed
>   the critical functionality, and want it merged instead of the
>   original, working version.
>
> I can only see two ways out ( which make sense) from this. The first is:
> we add my driver first and then your specific changes on top of it.
>

If you want your driver merged, then you would have to submit it
again, addressing
my review comments. However, I have just posted a v2 and it would be nice if
you can review it and test it.

Thanks,
-- 
Ezequiel García, VanguardiaSur
www.vanguardiasur.com.ar
