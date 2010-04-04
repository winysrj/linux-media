Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:57881 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0DDWIx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Apr 2010 18:08:53 -0400
Received: by fxm27 with SMTP id 27so637837fxm.28
        for <linux-media@vger.kernel.org>; Sun, 04 Apr 2010 15:08:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <o2lbcb3ef431004041455x49a28290h3fe76b498735e029@mail.gmail.com>
References: <bcb3ef431003081127y43d6d785jdc34e845fa07e746@mail.gmail.com>
	 <a3ef07921003081241t16e1a63ag1d8f93ebe35f15f2@mail.gmail.com>
	 <201003092133.12235.liplianin@me.by>
	 <o2lbcb3ef431004041455x49a28290h3fe76b498735e029@mail.gmail.com>
Date: Mon, 5 Apr 2010 02:08:52 +0400
Message-ID: <o2p1a297b361004041508ob3c0d940k723d518abee94ede@mail.gmail.com>
Subject: Re: s2-liplianin, mantis: sysfs: cannot create duplicate filename
	'/devices/virtual/irrcv'
From: Manu Abraham <abraham.manu@gmail.com>
To: MartinG <gronslet@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 5, 2010 at 1:55 AM, MartinG <gronslet@gmail.com> wrote:

> Thanks, I've pulled the linuxtv tree, and it compiled, installed and
> seems to work just fine. No more "mantis_ack_wait (0): Slave RACK Fail
> !" I hope ;).

That error is from the older version of my driver. You don't find that
error in the updated version. Always try to use a stabler tree[1], or
a development version[2], rather than one having unknown changes,
unless you know what you are doing: which might not be what happened
to you. Use the stabler version if you are faint hearted, or the
development version, if you like to be on the bleeding edge of
development. Anything other than that, who knows ..


Manu

[1] http://linuxtv.org/hg/v4l-dvb
[2] http://jusst.de/hg/mantis-v4l-dvb
