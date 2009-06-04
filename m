Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64344 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZFDP2E (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2009 11:28:04 -0400
Received: by fxm9 with SMTP id 9so847792fxm.37
        for <linux-media@vger.kernel.org>; Thu, 04 Jun 2009 08:28:05 -0700 (PDT)
Message-ID: <4A280430.9030500@gmail.com>
Date: Thu, 04 Jun 2009 19:28:16 +0200
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: moinejf@free.fr
CC: linux-media@vger.kernel.org
Subject: gspca: usb_set_interface() required for ISOC ep with altsetting of
 0?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I noted that in get_ep() in drivers/media/video/gspca/gspca.c
usb_set_interface() is not called for an ISOC endpoint with an
altsetting of 0. Is that ok?

Roel
