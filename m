Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44072 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaAHSuN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 13:50:13 -0500
Received: by mail-ob0-f170.google.com with SMTP id uy5so172097obc.15
        for <linux-media@vger.kernel.org>; Wed, 08 Jan 2014 10:50:12 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 8 Jan 2014 10:50:12 -0800
Message-ID: <CABMudhTFmbv-PrNiGcW2yoGPiXuJ13fCmoqDFFBJfEjLk=gSgw@mail.gmail.com>
Subject: How can I find out what is the driver for device node '/dev/video11'
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In linux kernel, a device (e.g. codec) can register as a file (e.g.
/dev/video11).

How can I find out from the code which driver is registered as
'/dev/video11'. i.e. what is the driver will be invoked when I
open('/dev/video11', O_RDWR,0) in my user space code?
