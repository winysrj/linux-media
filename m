Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50917 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0CHFJC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Mar 2010 00:09:02 -0500
Received: by wya21 with SMTP id 21so3069992wya.19
        for <linux-media@vger.kernel.org>; Sun, 07 Mar 2010 21:08:59 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 8 Mar 2010 05:08:58 +0000
Message-ID: <600adaf51003072108u42359bd7o8fd5308395582f39@mail.gmail.com>
Subject: Some questions
From: Tiago Maluta <tiago.maluta@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

One of topic of my final course work that I thought is create a simple way to
demonstrate the DVB in Linux (software-only approach). Something like:

FRONTEND -> DEMUX -> AUDIO/VIDEO -> PLAYER

Notes:
- I'm omitting the block referring to SEC and CA.
- As I'm in Brazil I'm focusing in ISDB-T standard

My first step is create a code based in dvb_dummy_fe.c to take a place of a
'dummy' ISDB-T frontend. After that created a userspace program to 'inject' a
TS into the frontend. I know that is useless if I already have the Transport
Stream but I like to at least pass trough 'frontendX' device.

1) Where is /dev/dvb/adapter/frontendX created? I saw that in dvbdev.c,
but when I load dvb_dummy_fe.ko frontendX would not have to appear?

2) As dvb_dummy_fe.c doesn't have module_init() and module_exit() definition.
(and noted that this happens in other files in frontend/ too) is API
(Frontend Function Calls) used to access,
i.e: ioctl(fd, FE_GET_FRONTEND, struct ....)

Other information:

- I'm using 2.6.33-git
- $ grep ^CONFIG_DVB .config

    CONFIG_DVB_CORE=y
    CONFIG_DVB_MAX_ADAPTERS=8
    CONFIG_DVB_CAPTURE_DRIVERS=y
    CONFIG_DVB_FE_CUSTOMISE=y
    CONFIG_DVB_DUMMY_FE=m


Another topic that I would add is my work is regarded to userspace tools [1]
to processing the sections related do ISDB-T.

[1] http://linuxtv.org/hg/~pb/dvb-apps-isdbt

I would appreciate if developers in this maillist point some directions. Mauro
and Patrick answered some private emails with questions, but I like to exchange
discussion.

Maybe what I said it thoroughly out of context and I'm thinking on the
wrong way,
but except linuxtv.org and kernel Documentation/ it's difficult to get
 expertise
in topics regarded what could be a cool way to do a good final
course work.

Kind regards,

--tm
