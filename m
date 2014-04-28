Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f68.google.com ([209.85.219.68]:48116 "EHLO
	mail-oa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaD1ErN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Apr 2014 00:47:13 -0400
Received: by mail-oa0-f68.google.com with SMTP id i4so2106090oah.3
        for <linux-media@vger.kernel.org>; Sun, 27 Apr 2014 21:47:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535CAE24.2070603@gmail.com>
References: <535CAE24.2070603@gmail.com>
Date: Mon, 28 Apr 2014 07:47:12 +0300
Message-ID: <CAPuGpVx6oj_XAaQiUgVu_O3=4kHCLJ5m7eTt6xaj95YwUzrMfg@mail.gmail.com>
Subject: Re: saa7134: Add keymaps for Avermedia M733A with IR model RM-KS
From: triniton adam <trinitonadam@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remote Control Buttons (Model RM-KS) and their function:

http://i.imgur.com/qDiPzFU.png

On Sun, Apr 27, 2014 at 10:13 AM, Triniton Adam <trinitonadam@gmail.com> wrote:
> Hi,
> I have attempted to add support for saa7134 Avermedia M733A remote with IR
> model RM-KS
> which is endowed with this model in Eastern Europe.
>
> I not familiar with git and LinuxTV GIT patch system but I write new
> rc-avermedia-m733a-rm-k6.c
> keymap file which is based on an addition of rc-avermedia-m733a-rm-k6.c and
> rc-avermedia-rm-ks.c
> files.
>
> I would like someone who is familiar with adding patches for LinuxTV to
> produce one patch
> for Avermedia M733A remotes.
>
> Here is new rc-avermedia-m733a-rm-k6.c:
>
> /* avermedia-m733a-rm-k6.h - Keytable for avermedia_m733a_rm_k6 Remote
> Controller
>  *
>  * Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>  */
>
> #include <media/rc-map.h>
> #include <linux/module.h>
>
> static struct rc_map_table avermedia_m733a_rm_k6[] = {
>     /* Avermedia M733A with IR model RM-K6 */
>     { 0x0401, KEY_POWER2 },
>     { 0x0406, KEY_MUTE },
>     { 0x0408, KEY_MODE },     /* TV/FM */
>
>     { 0x0409, KEY_1 },
>     { 0x040a, KEY_2 },
>     { 0x040b, KEY_3 },
>     { 0x040c, KEY_4 },
>     { 0x040d, KEY_5 },
>     { 0x040e, KEY_6 },
>     { 0x040f, KEY_7 },
>     { 0x0410, KEY_8 },
>     { 0x0411, KEY_9 },
>     { 0x044c, KEY_DOT },      /* '.' */
>     { 0x0412, KEY_0 },
>     { 0x0407, KEY_REFRESH },  /* Refresh/Reload */
>
>     { 0x0413, KEY_AUDIO },
>     { 0x0440, KEY_SCREEN },   /* Full Screen toggle */
>     { 0x0441, KEY_HOME },
>     { 0x0442, KEY_BACK },
>     { 0x0447, KEY_UP },
>     { 0x0448, KEY_DOWN },
>     { 0x0449, KEY_LEFT },
>     { 0x044a, KEY_RIGHT },
>     { 0x044b, KEY_OK },
>     { 0x0404, KEY_VOLUMEUP },
>     { 0x0405, KEY_VOLUMEDOWN },
>     { 0x0402, KEY_CHANNELUP },
>     { 0x0403, KEY_CHANNELDOWN },
>
>     { 0x0443, KEY_RED },
>     { 0x0444, KEY_GREEN },
>     { 0x0445, KEY_YELLOW },
>     { 0x0446, KEY_BLUE },
>
>     { 0x0414, KEY_TEXT },
>     { 0x0415, KEY_EPG },
>     { 0x041a, KEY_TV2 },      /* PIP */
>     { 0x041b, KEY_CAMERA },      /* Snapshot */
>
>     { 0x0417, KEY_RECORD },
>     { 0x0416, KEY_PLAYPAUSE },
>     { 0x0418, KEY_STOP },
>     { 0x0419, KEY_PAUSE },
>
>     { 0x041f, KEY_PREVIOUS },
>     { 0x041c, KEY_REWIND },
>     { 0x041d, KEY_FORWARD },
>     { 0x041e, KEY_NEXT },
>
>     /* Avermedia M733A with IR model RM-KS */
>     { 0x0501, KEY_POWER2 },
>     { 0x0502, KEY_CHANNELUP },
>     { 0x0503, KEY_CHANNELDOWN },
>     { 0x0504, KEY_VOLUMEUP },
>     { 0x0505, KEY_VOLUMEDOWN },
>     { 0x0506, KEY_MUTE },
>     { 0x0507, KEY_RIGHT },
>     { 0x0508, KEY_RED },
>     { 0x0509, KEY_1 },
>     { 0x050a, KEY_2 },
>     { 0x050b, KEY_3 },
>     { 0x050c, KEY_4 },
>     { 0x050d, KEY_5 },
>     { 0x050e, KEY_6 },
>     { 0x050f, KEY_7 },
>     { 0x0510, KEY_8 },
>     { 0x0511, KEY_9 },
>     { 0x0512, KEY_0 },
>     { 0x0513, KEY_AUDIO },
>     { 0x0515, KEY_EPG },
>     { 0x0516, KEY_PLAY },
>     { 0x0517, KEY_RECORD },
>     { 0x0518, KEY_STOP },
>     { 0x051c, KEY_BACK },
>     { 0x051d, KEY_FORWARD },
>     { 0x054d, KEY_LEFT },
>     { 0x0556, KEY_ZOOM },
> };
>
> static struct rc_map_list avermedia_m733a_rm_k6_map = {
>     .map = {
>         .scan    = avermedia_m733a_rm_k6,
>         .size    = ARRAY_SIZE(avermedia_m733a_rm_k6),
>         .rc_type = RC_TYPE_NEC,
>         .name    = RC_MAP_AVERMEDIA_M733A_RM_K6,
>     }
> };
>
> static int __init init_rc_map_avermedia_m733a_rm_k6(void)
> {
>     return rc_map_register(&avermedia_m733a_rm_k6_map);
> }
>
> static void __exit exit_rc_map_avermedia_m733a_rm_k6(void)
> {
>     rc_map_unregister(&avermedia_m733a_rm_k6_map);
> }
>
> module_init(init_rc_map_avermedia_m733a_rm_k6)
> module_exit(exit_rc_map_avermedia_m733a_rm_k6)
>
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Mauro Carvalho Chehab");
>
