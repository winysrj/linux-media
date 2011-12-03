Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe05.c2i.net ([212.247.154.130]:46114 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753505Ab1LCSVL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Dec 2011 13:21:11 -0500
From: Hans Petter Selasky <hselasky@c2i.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because of worrying about possible misusage?
Date: Sat, 3 Dec 2011 19:13:32 +0100
Cc: VDR User <user.vdr@gmail.com>,
	Andreas Oberritter <obi@linuxtv.org>, HoP <jpetrous@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <CAA7C2qjfWW8=kePZDO4nYR913RyuP-t+u8P9LV4mDh9bANr3=Q@mail.gmail.com> <20111203174247.0bbab100@lxorguk.ukuu.org.uk>
In-Reply-To: <20111203174247.0bbab100@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112031913.32503.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Some input from the sideline reading this discussion. As a FreeBSD'er I would 
very much like to see two things happen:

- vtunerc goes into userspace like a client/server daemon pair using CUSE and 
can support _any_ /dev/dvb/adapter, also those created by CUSE itself. That 
means I could potentially use vtunerc in FreeBSD with drivers like cx88:

http://corona.homeunix.net/cx88wiki

- DVB-X solution in Linux gets mmap support to avoid endless copying of data 
between kernel and userspace.

--HPS
