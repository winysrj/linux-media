Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.telros.ru ([83.136.244.21]:54525 "EHLO mail.telros.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab3CFKXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Mar 2013 05:23:23 -0500
Date: Wed, 6 Mar 2013 13:48:13 +0400
From: volokh84@gmail.com
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: tw2804.c
Message-ID: <20130306094813.GA1888@VPir.1>
References: <20130305194828.8A75511E00AE@alastor.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130305194828.8A75511E00AE@alastor.dyndns.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Hans

I found in d8077d2df184f3ef63ed9ff4579d41ca64e12855 commit,
that V4L2_CTRL_FLAG_VOLATILE flag was disabled for some STD controls
and fully disabled g_ctrl iface. So How can userspace know about changing some values?

Or is that right?

Regards,
Volokh

