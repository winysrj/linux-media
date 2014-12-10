Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:59712 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaLJQ2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Dec 2014 11:28:00 -0500
Message-ID: <5488748B.7060703@collabora.com>
Date: Wed, 10 Dec 2014 11:27:55 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: LibV4L2 and CREATE_BUFS issues
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

we recently fixed our CREATE_BUFS support in GStreamer master. It works
nicely with UVC drivers. The problem is that libv4l2 isn't aware of it,
and endup taking terribly decision the least quickly lead to crash.

I'm not sure what that right approach. It seems non-trivial to support
it, at least it would require a bit more knowledge of the converter code
and memory model. Maybe we should at least make sure that CREATE_BUF
fails if we are doing conversion ? Some input on that would be appreciated.

cheers,
Nicolas
