Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:48667 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab1LBMFE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Dec 2011 07:05:04 -0500
To: <linux-media@vger.kernel.org>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of
 worrying about possible =?UTF-8?Q?misusage=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 02 Dec 2011 13:05:02 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
In-Reply-To: <4ED8BB13.7080407@linuxtv.org>
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <4ED7BBA3.5020002@redhat.com> <CAJbz7-1_Nb8d427bOMzCDbRcvwQ3QjD=2KhdPQS_h_jaYY5J3w@mail.gmail.com> <4ED7E5D7.8070909@redhat.com> <4ED805CB.5020302@linuxtv.org> <4ED8B327.9090505@redhat.com> <4ED8BB13.7080407@linuxtv.org>
Message-ID: <018e89947ac5af62be7ebc9a1234ecab@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 02 Dec 2011 12:48:35 +0100, Andreas Oberritter <obi@linuxtv.org>

wrote:

>> Btw, applications like vdr, vlc, kaffeine and others already implement

>> their

>> own ways to remotelly access the DVB devices without requiring any

>> kernelspace piggyback driver.

> 

> Can vdr, vlc, kaffeine use remote tuners on hosts not running vdr, vlc

> or kaffeine? Should we implement networking protocols in scan, w_scan,

> czap, tzap, szap, mplayer, dvbsnoop, dvbstream, etc. instead?



VLC does not support remote control of digital (nor analog) tuners as of

today.



-- 

Rémi Denis-Courmont

http://www.remlab.net/
