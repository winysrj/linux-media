Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:37289 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbZFIBpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 21:45:33 -0400
Received: by gxk10 with SMTP id 10so2583205gxk.13
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2009 18:45:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 8 Jun 2009 21:45:34 -0400
Message-ID: <246c01f50906081845j4d8d062enbd9644edb0cf4d1d@mail.gmail.com>
Subject: SPCA505 and 506 with X10 VA11A
From: Joe Belford <joebelford@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an X10 VA11A I'd like to get working with V4L2.  As some are
probably aware this device shares a vendor/product id with another
webcam that uses the spca505 module.  I've been through the source for
these modules and noticed the fixme's and was wondering If someone
could suggest a starting point to get this working.  I have some
experience with linux driver development working with handheld
devices.

Thanks,
Joe
