Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:50472 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZF3CIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 22:08:41 -0400
Received: by gxk26 with SMTP id 26so4594425gxk.13
        for <linux-media@vger.kernel.org>; Mon, 29 Jun 2009 19:08:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <829197380906291759q7ded8117tee12214073d85e67@mail.gmail.com>
References: <c21478f30906291719r41ba5accu75c5bfd3dcb81276@mail.gmail.com>
	 <829197380906291759q7ded8117tee12214073d85e67@mail.gmail.com>
Date: Tue, 30 Jun 2009 12:08:44 +1000
Message-ID: <c21478f30906291908y2f601577sfc94e7abc378d9e5@mail.gmail.com>
Subject: Re: XC2028 Tuner - firmware issues
From: Andrej Falout <andrej@falout.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The dvb-usb framework doesn't have any analog support.  Therefore none
> of the dib0700 based devices will support analog either (the problem
> is not specific to your device and has nothing to do with the xc3028
> firmware).

Thanks for this, Devin. Are there no plans to support analog in
dvb-usb in the future, or is someone maybe working on this?

Cheers,
Andrej Falout
