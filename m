Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:35727 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdICUFY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 16:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Sun, 3 Sep 2017 22:05:23 +0200
Message-ID: <CAJbz7-29pV9u0UZUC+sUtncsCbqbjNToA-yANJ7hExLRFw_tiQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/26] Improve DVB documentation and reduce its gap
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> There is still a gap at the CA API, as there are three ioctls that are used
> only by a few drivers and whose structs are not properly documented:
> CA_GET_MSG, CA_SEND_MSG and CA_SET_DESCR.
>
> The first two ones seem to be related to a way that a few drivers
> provide to send/receive messages.

I never seen usage of such R/W ioctls, all drivers I have access to
are using read()/write() variant of communication.

Yet, I was unable to get what
> "index" and "type" means on those ioctls. The CA_SET_DESCR is
> only supported by av7110 driver, and has an even weirder
> undocumented struct. I was unable to discover at the Kernel, VDR
> or Kaffeine how those structs are filled. I suspect that there's
> something wrong there, but I won't risk trying to fix without
> knowing more about them. So, let's just document that those
> are needing documentation :-)
>


1) #define CA_SET_DESCR      _IOW('o', 134, ca_descr_t)
============================================

CA_SET_DESCR is used for feeding descrambler device
with correct keys (called here "control words") what
allows to get services unscrambled.

The best docu is:

"Digital Video Broadcasting (DVB);
Support for use of the DVB Scrambling Algorithm version 3
within digital broadcasting systems"

Defined as DVB Document A125 and publicly
available here:

https://www.dvb.org/resources/public/standards/a125_dvb-csa3.pdf


typedef struct ca_descr {
        unsigned int index;
        unsigned int parity;    /* 0 == even, 1 == odd */
        unsigned char cw[8];
} ca_descr_t;

The 'index' is adress of the descrambler instance, as there exist
limited number of them (retieved by CA_GET_DESCR_INFO).
See below:


2) #define CA_SET_PID        _IOW('o', 135, ca_pid_t)
=======================================

The second ioctl was used to link particular PID with particular
descrambler, what means that all such pids (you are allowed
to create n-to-1 link), can be descrambled by one descrambler.

This is needed in case of multiservice descrambling, when
usually exist one key (control word) per one service (so all PIDs
for one service have to be linked with one descrambler)

Without this ioctl there is no way to address particular
descrambler and so no way to use more then ONE descrambler
per demux

/Honza
