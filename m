Return-path: <mchehab@localhost>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60349 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080Ab1GMIfR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 04:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107121143500.31381-100000@netrider.rowland.org>
References: <CACVXFVOL67EjcMxfizC0JR-=wraNTneZicw_OBfCGkseZh7Lig@mail.gmail.com>
	<Pine.LNX.4.44L0.1107121143500.31381-100000@netrider.rowland.org>
Date: Wed, 13 Jul 2011 16:35:16 +0800
Message-ID: <CACVXFVP6T19WgdZbrTt+2R+Mh4ZWyv7ZmwBv3eC9hj7L2=3Yxw@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On Tue, Jul 12, 2011 at 11:44 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> Maybe this device needs a USB_QUIRK_RESET_RESUME entry in quirks.c.

RESET_RESUME quirk makes things worse, now stream data is not received from
the camera at all even in resume from runtime suspend case. So the quirk can
make the device totally useless, :-)

thanks,
-- 
Ming Lei
