Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40574 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675Ab3GaSrc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 14:47:32 -0400
Received: by mail-wi0-f181.google.com with SMTP id en1so1002628wid.14
        for <linux-media@vger.kernel.org>; Wed, 31 Jul 2013 11:47:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
From: Luis Polasek <pola@sol.info.unlp.edu.ar>
Date: Wed, 31 Jul 2013 15:47:10 -0300
Message-ID: <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
Subject: Fwd: dib8000 scanning not working on 3.10.3
To: linux-media@vger.kernel.org
Cc: "jbucar@lifia.info.unlp.edu.ar" <jbucar@lifia.info.unlp.edu.ar>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I just upgraded my kernel to 3.10.3, and dib8000 scanning does not
work anymore.

I tested using dvbscan (from dvb-apps/util/) and w_scan on a Prolink
Pixelview SBTVD (dib8000 module*).This tools worked very well on
version 3.9.9 , but now it does not produces any result, and also
there are no error messages in the logs (dmesg).

Can you please point me out to what is wrong in my kernel, or tell me
which tool did you used to test dvb scanning on this kernel version ?

Thanks and regards...


*: 9.863433] dvb-usb: Prolink Pixelview SBTVD successfully initialized
and connected.
