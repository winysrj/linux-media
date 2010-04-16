Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37973 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0DPEry (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 00:47:54 -0400
Received: by ewy20 with SMTP id 20so757918ewy.1
        for <linux-media@vger.kernel.org>; Thu, 15 Apr 2010 21:47:52 -0700 (PDT)
Date: Fri, 16 Apr 2010 14:50:14 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] saa7134 with many MPEG devices
Message-ID: <20100416145014.304756c1@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All

Now saa7134 can work only with one MPEG device. For our new TV card
need support two or many.

I think we can rework this part.

Rework struct saa7134_mpeg_ops as duble linked list
add pointers to next and previose mops pointer.

Add special function for call this devices.

What you thinbk about it??

With my best regards, Dmitry.
