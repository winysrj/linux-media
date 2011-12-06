Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:46958 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab1LFOTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 09:19:35 -0500
From: "=?utf-8?q?R=C3=A9mi?= Denis-Courmont" <remi@remlab.net>
To: linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of worrying about possible misusage?
Date: Tue, 6 Dec 2011 16:19:30 +0200
Cc: linux-kernel@vger.kernel.org
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4EDE1733.8060409@redhat.com> <4EDE1D57.90307@linuxtv.org>
In-Reply-To: <4EDE1D57.90307@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112061619.31357.remi@remlab.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le mardi 6 décembre 2011 15:49:11 Andreas Oberritter, vous avez écrit :
> You don't need to wait for write-only operations. Basically all demux
> ioctls are write-only. Since vtunerc is using dvb-core's software demux
> *locally*, errors for invalid arguments etc. will be returned as usual.

That's a limitation, not a feature.
You should not transmit unwanted programs over the network, nor copy them to 
kernel space.

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
