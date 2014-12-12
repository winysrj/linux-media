Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:32798 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967883AbaLLNxF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Dec 2014 08:53:05 -0500
Received: by mail-oi0-f50.google.com with SMTP id a141so5191986oig.37
        for <linux-media@vger.kernel.org>; Fri, 12 Dec 2014 05:53:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <548AEE11.50303@xs4all.nl>
References: <1415218274-28132-1-git-send-email-andrey.utkin@corp.bluecherry.net>
	<548AEE11.50303@xs4all.nl>
Date: Fri, 12 Dec 2014 15:53:04 +0200
Message-ID: <CAM_ZknU_5MYEkC7VTD3-M1vcvqoTXtg-Dy-iozpky0TSOymEgQ@mail.gmail.com>
Subject: Re: [PATCH] solo6x10: just pass frame motion flag from hardware, drop
 additional handling as complicated and unstable
From: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
	Linux Media <linux-media@vger.kernel.org>,
	m.chehab@samsung.com, "hans.verkuil" <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 12, 2014 at 3:30 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> I have tested this and it looks good. I am not sure what problems I had
> originally that caused me to write that code, since it is now functioning
> as expected.
>
> So you can expect this patch to be part of the next 3.20 pull request I'll
> post.
>
> Sorry for the delay.

Thanks.

-- 
Bluecherry developer.
