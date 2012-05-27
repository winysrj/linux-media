Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab2E0JGW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 05:06:22 -0400
Message-ID: <4FC1EE93.9020003@redhat.com>
Date: Sun, 27 May 2012 11:06:27 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: halli manjunatha <hallimanju@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Discussion: How to deal with radio tuners which can tune to multiple
 bands
References: <1337032913-18646-1-git-send-email-manjunatha_halli@ti.com> <1337032913-18646-3-git-send-email-manjunatha_halli@ti.com> <201205201152.12948.hverkuil@xs4all.nl> <CAMT6Pyd6e8zgkLEk_dpGTxiPZDippDe_YgedNRpUkJzA9X5hvw@mail.gmail.com> <4FBD2C80.3060406@redhat.com>
In-Reply-To: <4FBD2C80.3060406@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Just noticed the following on:
http://linuxtv.org/downloads/v4l-dvb-apis/tuner.html#id2570531

"This specification does not define radio output devices.", iow no
radio modulators, but we agreed upon making the band changes to
the modulator too, and this makes sense because AFAIK we do support
radio modulators.

I hit this while working on adding support for the proposed API to
v4l2-ctl, as I wanted to only print the band stuff for radio type
devices, but the modulator struct has no type!

Regards,

Hans
