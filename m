Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:33293 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1LBLkp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 06:40:45 -0500
To: <linux-media@vger.kernel.org>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of
 worrying about possible =?UTF-8?Q?misusage=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 02 Dec 2011 12:40:43 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
In-Reply-To: <4ED8B327.9090505@redhat.com>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com> <4ED7E5D7.8070909@redhat.com> <4ED805CB.5020302@linuxtv.org> <4ED8B327.9090505@redhat.com>
Message-ID: <03e495a7c399d9062d7e4edd8ee733c2@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 02 Dec 2011 09:14:47 -0200, Mauro Carvalho Chehab

<mchehab@redhat.com> wrote:

> If you're referring to the device name under /dev, a daemon emulating

> a physical device could create Unix sockets under /dev/dvb.



Hmm, how would that work if a real physical device gets added afterward

and udev wants to create the nodes?



-- 

Rémi Denis-Courmont

http://www.remlab.net/
