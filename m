Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47739 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab0CHUl2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Mar 2010 15:41:28 -0500
Received: by vws9 with SMTP id 9so2955816vws.19
        for <linux-media@vger.kernel.org>; Mon, 08 Mar 2010 12:41:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <bcb3ef431003081127y43d6d785jdc34e845fa07e746@mail.gmail.com>
References: <bcb3ef431003081127y43d6d785jdc34e845fa07e746@mail.gmail.com>
Date: Mon, 8 Mar 2010 12:41:26 -0800
Message-ID: <a3ef07921003081241t16e1a63ag1d8f93ebe35f15f2@mail.gmail.com>
Subject: Re: s2-liplianin, mantis: sysfs: cannot create duplicate filename
	'/devices/virtual/irrcv'
From: VDR User <user.vdr@gmail.com>
To: MartinG <gronslet@gmail.com>
Cc: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This isn't an answer to your questions but I don't recommend using the
s2-liplianin tree as it contains timing patches which can cause
serious damage to your tuner.  This has also been confirmed by the
manufacturer as well and to my knowledge has unfortunately not been
reverted in that tree.

I strongly urge you to use either of these _safe_ trees:

http://jusst.de/hg/mantis-v4l-dvb (for development drivers, which may
still be stable)
http://linuxtv.org/hg/v4l-dvb (for more stable drivers)
