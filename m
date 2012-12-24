Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:48916 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2LXLZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Dec 2012 06:25:21 -0500
Received: by mail-bk0-f44.google.com with SMTP id w11so3271459bku.3
        for <linux-media@vger.kernel.org>; Mon, 24 Dec 2012 03:25:20 -0800 (PST)
Message-ID: <50D83BB2.4070308@googlemail.com>
Date: Mon, 24 Dec 2012 12:25:38 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: em28xx: module parameter prefer_bulk ?
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

now that we prefer bulk transfers for webcams and isoc transfers for TV,
I wonder if prefer_bulk is still a good name for this module parameter.
What about something like 'usb_mode', 'usb_xfer_mode' or
'frame_xfer_mode' with 0=auto, 1=prefer isoc, 2=prefer bulk ?

Regards,
Frank
