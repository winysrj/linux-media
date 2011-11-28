Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60955 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1K1T3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 14:29:10 -0500
Received: by bke11 with SMTP id 11so8942465bke.19
        for <linux-media@vger.kernel.org>; Mon, 28 Nov 2011 11:29:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO=zWDJREu+AomDtuWTf5CaTwJh4BbQ79b4BtYJODhGvTqW9fg@mail.gmail.com>
References: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com>
	<CAO=zWDJREu+AomDtuWTf5CaTwJh4BbQ79b4BtYJODhGvTqW9fg@mail.gmail.com>
Date: Mon, 28 Nov 2011 20:29:08 +0100
Message-ID: <CAO=zWDJzDm2DbGhdPWH_gcQntBuEwymjJxc7onAwJm3b7_8XLw@mail.gmail.com>
Subject: Re: Status of RTL283xU support?
From: Maik Zumstrull <maik@zumstrull.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 26, 2011 at 17:20, Maik Zumstrull <maik@zumstrull.net> wrote:

> FYI, someone has contacted me off-list to point out that the newest(?)
> Realtek tree for these devices is available online:

Gave it a spin, built out of tree against Debian's Linux 3.0 binaries.
Basically works, you can get a signal, but has crashed my system a few
times. Removed it again. YMMV.
