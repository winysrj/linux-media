Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59819 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2DWLBI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 07:01:08 -0400
Received: by vcqp1 with SMTP id p1so7871481vcq.19
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2012 04:01:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WVeXD99FOVNLJ+CVjPEiKrH9dNijM6Rb-G2uz8v_v_j-Q@mail.gmail.com>
References: <CAL9G6WXZLdJqpivn2qNXb+oP9o4n=uyq6ywiRrzP13vmUYvaxw@mail.gmail.com>
	<4F6DDB10.8000503@redhat.com>
	<CAL9G6WUNp1gHibG74L8VXyJ0KPDYY+amKy3JZ7MBkjB8DBwERA@mail.gmail.com>
	<CALF0-+Uf=1tMKMtOJKEOLiHQ=brkW6JL67A5qtWSJ8uOM3ZfsA@mail.gmail.com>
	<4F8F13D8.5080407@redhat.com>
	<CAL9G6WVK=YKGOsB3VV_0B8RRvX0LnTNps1d=zTyV9mdfkirQ8g@mail.gmail.com>
	<CAJ_iqtbVzU9zg_ERvhrbVr1vdgXXhyxJYdAmT0F1h_2ixP-==Q@mail.gmail.com>
	<CAL9G6WVeXD99FOVNLJ+CVjPEiKrH9dNijM6Rb-G2uz8v_v_j-Q@mail.gmail.com>
Date: Mon, 23 Apr 2012 13:01:07 +0200
Message-ID: <CAJ_iqta7dEdcvi9P_nTTDxAZi0rKBzz5LUZW_cp444L20k58CQ@mail.gmail.com>
Subject: Re: dvb lock patch
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 21, 2012 at 2:18 PM, Josu Lazkano <josu.lazkano@gmail.com> wrote:
>
> Thanks Torfinn!
>
> I get it working with modules compilation, that great!

Good to hear that you got it working.

>
> apt-get install linux-source-3.2
> cd /usr/src/
> tar -xjvf linux-source-3.2.tar.bz2
> cd linux-source-3.2/
> wget http://kipdola.be/subdomain/linux-2.6.38-dvb-mutex.patch
> patch -p1 linux-2.6.38-dvb-mutex.patch (I must do it manually, maybe
> for the kernel version)
> cp /boot/config-3.2.0-2-686-pae .config
> cp ../linux-headers-3.2.0-2-686-pae/Module.symvers .
> make oldconfig
> make prepare
> make scripts
> make modules SUBDIRS=drivers/media/dvb/
> cp drivers/media/dvb/dvb-core/dvb-core.ko
> /lib/modules/3.2.0-2-686-pae/kernel/drivers/media/dvb/dvb-core/
> (reboot)
>
> I am not software developer and I have no idea what means "race
> conditions", is this sasc-ng or linux driver "problem"?

Sorry, I'm also not a developer, so I can't tell. :)
As long as the driver works, I'm happy.
-- 
Regards,
Torfinn Ingolfsen
