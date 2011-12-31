Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34366 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1LaLvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Dec 2011 06:51:25 -0500
Received: by iaeh11 with SMTP id h11so26688062iae.19
        for <linux-media@vger.kernel.org>; Sat, 31 Dec 2011 03:51:25 -0800 (PST)
Date: Sat, 31 Dec 2011 05:51:17 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: David Fries <david@fries.net>
Cc: Istvan Varga <istvan_v@mailbox.hu>, linux-media@vger.kernel.org,
	Darron Broad <darron@kewl.org>,
	Steven Toth <stoth@kernellabs.com>
Subject: Re: [git:v4l-dvb/for_v3.3] [media] cx88-dvb avoid dangling
 core->gate_ctrl pointer
Message-ID: <20111231115117.GB16802@elie.Belkin>
References: <E1RgiId-0003Qe-SC@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1RgiId-0003Qe-SC@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab wrote:

> Subject: [media] cx88-dvb avoid dangling core->gate_ctrl pointer
> Author:  David Fries <david@fries.net>
> Date:    Thu Dec 15 01:59:20 2011 -0300
>
> dvb_register calls videobuf_dvb_register_bus, but if that returns
> a failure the module will be unloaded without clearing the
> value of core->gate_ctrl which will cause an oops in macros
> called from video_open in cx88-video.c
>
> Signed-off-by: David Fries <David@Fries.net>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Istvan Varga <istvan_v@mailbox.hu>
> Cc: Jonathan Nieder <jrnieder@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

For what it's worth,
Acked-by: Jonathan Nieder <jrnieder@gmail.com>

Thanks.  Here are some patches to stop producing the spurious -ENOMEM
in the first place, and to start checking the return value from
dvb_net_init in other contexts more diligently.  Untested.  Bug
reports, patches in the same vein on top (just try "git grep -Ovi -e
dvb_net_init"), and other thoughts of all kinds welcome.

Jonathan Nieder (9):
  [media] DVB: dvb_net_init: return -errno on error
  [media] videobuf-dvb: avoid spurious ENOMEM when CONFIG_DVB_NET=n
  [media] dvb-bt8xx: use goto based exception handling
  [media] ttusb-budget: use goto for exception handling
  [media] flexcop: handle errors from dvb_net_init
  [media] dvb-bt8xx: handle errors from dvb_net_init
  [media] dm1105: handle errors from dvb_net_init
  [media] dvb-usb: handle errors from dvb_net_init
  [media] firedtv: handle errors from dvb_net_init

 drivers/media/dvb/b2c2/flexcop.c                  |    7 ++-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c               |   65 +++++++++++----------
 drivers/media/dvb/dm1105/dm1105.c                 |    5 +-
 drivers/media/dvb/dvb-core/dvb_net.c              |    4 +-
 drivers/media/dvb/dvb-usb/dvb-usb-dvb.c           |    8 ++-
 drivers/media/dvb/firewire/firedtv-dvb.c          |    5 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   40 +++++++------
 drivers/media/video/videobuf-dvb.c                |    7 +-
 8 files changed, 82 insertions(+), 59 deletions(-)
