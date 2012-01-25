Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64191 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072Ab2AYWQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 17:16:40 -0500
Received: by lagu2 with SMTP id u2so1024383lag.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 14:16:39 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 25 Jan 2012 23:16:39 +0100
Message-ID: <CAGa-wNOCn6GDu0DGM7xNrVagp0sdNeif25vuE+sPyU3aaegGAw@mail.gmail.com>
Subject: 290e locking issue
From: Claus Olesen <ceolesen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

just got 3.2.1-3.fc16.i686.PAE
the issue that the driver had to be removed for the 290e to work after
a replug is gone.
the issue that a usb mem stick cannot be mounted while the 290e is
plugged in still lingers.
one workaround is to unplug the 290e and wait a little (no need to
also remove the driver).
