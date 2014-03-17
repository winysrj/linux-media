Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:59416 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbaCQQey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Mar 2014 12:34:54 -0400
Received: by mail-qa0-f52.google.com with SMTP id m5so5486727qaj.25
        for <linux-media@vger.kernel.org>; Mon, 17 Mar 2014 09:34:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8310082.IFEfXeL82D@radagast>
References: <1394838259-14260-1-git-send-email-james@albanarts.com>
	<3611058.9Umk0NSF20@radagast>
	<CAKv9HNZipt2RWn1mf_X8Rt+udb-jmDLMDJThRJjYUmkovyCTzA@mail.gmail.com>
	<8310082.IFEfXeL82D@radagast>
Date: Mon, 17 Mar 2014 18:34:53 +0200
Message-ID: <CAKv9HNZBziVQLVoBpooq+enR2dsw1Skx1qZ4VAD6EqEtZRAN7g@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] rc: ir-rc5-sz-decoder: Add ir encoding support
From: =?ISO-8859-1?Q?Antti_Sepp=E4l=E4?= <a.seppala@gmail.com>
To: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16 March 2014 23:18, James Hogan <james@albanarts.com> wrote:
> Fair enough. So changing the minimum rc5-sz masks to 0x3fff sounds reasonable
> to allow toggle to be controlled.
>
> Just to clarify though, so you mean that the remote uses toggle=1 first (and
> in repeat codes) unless you press it a second time (new keypress) within a
> short amount of time?
> I.e. like this?
> Press   message toggle=1
>                 repeat toggle=1
>                 repeat toggle=1
> unpress
> Press   message toggle=!last_toggle only if within X ms, 1 otherwise
>

Actually studying this a little closer it seems that it indeed behaves
like a "toggle":

Press   message toggle=1
                repeat toggle=1
                repeat toggle=1
unpress
Press   message toggle=!last_toggle, always

So the toggle is inverted between presses and its value is kept during
repeat. It however seems to behave a little bit sporadically here
tending to set the toggle bit on more often than off.

Anyway I think that allowing the toggle bit to be set in the scancode
does not really hurt. I guess most of the time people will use the
scancodes without the toggle bit.

Br,
-Antti
