Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61992 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab0HCGoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 02:44:32 -0400
Received: by iwn7 with SMTP id 7so4865393iwn.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 23:44:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
References: <AANLkTi=-ai2mZHiEmiEpKq9A-CifSPQDagrE03gDqpHv@mail.gmail.com>
Date: Mon, 2 Aug 2010 23:44:32 -0700
Message-ID: <AANLkTikZD32LC12bT9wPBQ5+uO3Msd8Sw5Cwkq5y3bkB@mail.gmail.com>
Subject: Re: V4L hg tree fails to compile against latest stable kernel 2.6.35
From: VDR User <user.vdr@gmail.com>
To: "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 2, 2010 at 11:36 PM, VDR User <user.vdr@gmail.com> wrote:
> Any idea when this will be fixed?

Sorry, forgot to paste in the details:

make -C /lib/modules/2.6.35.amd.080210.2/build
SUBDIRS=/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/linux-2.6.35'
  CC [M]  /usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvbdev.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dmxdev.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_demux.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_filter.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_ca_en50221.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_frontend.o
  CC [M]  /usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.o
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1190:
warning: 'struct dev_mc_list' declared inside parameter list
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1190:
warning: its scope is only this definition or declaration, which is
probably not what you want
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c: In
function 'dvb_set_mc_filter':
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1197:
error: dereferencing pointer to incomplete type
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c: In
function 'wq_set_multicast_list':
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1247:
error: 'struct net_device' has no member named 'mc_list'
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1249:
error: dereferencing pointer to incomplete type
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1249:
warning: left-hand operand of comma expression has no effect
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1249:
warning: value computed is not used
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1250:
warning: passing argument 2 of 'dvb_set_mc_filter' from incompatible
pointer type
/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.c:1190:
note: expected 'struct dev_mc_list *' but argument is of type 'struct
dev_mc_list *'
make[3]: *** [/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l/dvb_net.o]
Error 1
make[2]: *** [_module_/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l]
Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.35'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/usr/local/dvb/v4l.source/v4l.20100802/v4l-dvb/v4l'
make: *** [all] Error 2
