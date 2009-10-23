Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40110 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZJWHqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Oct 2009 03:46:01 -0400
Subject: A driver for TI WL1273 FM Radio
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: Linux-Media <linux-media@vger.kernel.org>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	ext Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
References: <1249729833-24975-1-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-2-git-send-email-eduardo.valentin@nokia.com>
	 <1249729833-24975-3-git-send-email-eduardo.valentin@nokia.com>
Content-Type: text/plain
Date: Fri, 23 Oct 2009 10:45:53 +0300
Message-Id: <1256283953.5953.148.camel@masi.ntc.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

I have written a driver for the TI WL1273 FM Radio but it's not yet
quite ready for up-streaming because of its interface. Now I've started
to change the interface to v4l2 and I'm following Eduardo Valentin's
Si4713 TX driver as an example. However, WL1273 radio has RX and TX so
there are things that Eduardo's driver doesn't cover. For example: the
driver needs a mode switch for switching between TX and RX. Should that
be implemented as an extended control or should there be a new IOCTL
added to the v4l2 API? etc...

Also I've added some things to the ivtv-radio tool. Should I try to
"up-stream" those as well?

Cheers, Matti A.



