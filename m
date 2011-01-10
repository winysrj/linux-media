Return-path: <mchehab@pedra>
Received: from smtp23.services.sfr.fr ([93.17.128.22]:13813 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1AJM4n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 07:56:43 -0500
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2317.sfr.fr (SMTP Server) with ESMTP id B53497000087
	for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 13:56:41 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (unknown [93.4.162.234])
	by msfrf2317.sfr.fr (SMTP Server) with SMTP id 6C8687000085
	for <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 13:56:41 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.4.162.234] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 10 Jan 2011 13:56:28 +0100
Subject: Re: [REGRESSION: wm8775, ivtv] Please revert commit
 fcb9757333df37cf4a7feccef7ef6f5300643864
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Eric Sharkey <eric@lisaneric.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	auric <auric@aanet.com.au>, David Gesswein <djg@pdp8online.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-users@ivtvdriver.org, ivtv-devel@ivtvdriver.org
In-Reply-To: <1294663149.2084.41.camel@morgan.silverblock.net>
References: <1293843343.7510.23.camel@localhost>
	 <AANLkTimHh4aS-6cp-CsX68WVSF6U+k6gb2mBSwkhd1Xn@mail.gmail.com>
	 <1294094056.10094.41.camel@morgan.silverblock.net>
	 <1294488550.9475.20.camel@gagarin>  <1294496528.2443.85.camel@localhost>
	 <1294512347.16924.28.camel@gagarin>
	 <1294663149.2084.41.camel@morgan.silverblock.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 13:56:27 +0100
Message-ID: <1294664187.3340.9.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 2011-01-10 at 07:39 -0500, Andy Walls wrote:
[snip]
> I do see one problem with your patch at the moment:
> 
> diff --git a/include/media/wm8775.c b/include/media/wm8775.c
> ...
> +       sd->grp_id = WM8775_GID; /* subdev group id */
> ...
> diff --git a/include/media/wm8775.h b/include/media/wm8775.h
> ...
> +/* subdev group ID */
> +#define WM8775_GID (1 << 0)
> +
> ...
> 
> 
> The wm8775 module probably should not define WM8775_GID and definitely
> should not set sd->grp_id.  The sd->grp_id is for the bridge driver's
> use for that v4l2_subdev instance.  Some bridge drivers may expect it to
> be 0 unless they set it themselves.  The group ID values should be
> defined in the bridge driver, and the sd->grp_id field should be set by
> the bridge driver.
> 
> You would want to do that in cx88.  See cx23885, ivtv, and cx18 as
> examples of bridge drivers that use the group id field.

You know what, life's too short.  I've spent far too long on this at the
expense of far more interesting projects.  Every time I put some effort
in someone says just one more thing...  I get the message.  I'll just
keep the patch for my personal use.  For those that are interested I'll
maintain a copy here:
http://www.softsystem.co.uk/download/patches/nova-2.6.37.patch

-- Lawrence


