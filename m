Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:24848 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZERNy4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 09:54:56 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1886485wfd.4
        for <linux-media@vger.kernel.org>; Mon, 18 May 2009 06:54:57 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 18 May 2009 09:54:57 -0400
Message-ID: <829197380905180654i31bde47ep626b40d2dde9e7b@mail.gmail.com>
Subject: xc5000 users: new firmware required!
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new xc5000 code was merged this morning, which requires users to
update their firmware.  If you updated to the latest v4l-dvb and your
card stopped working, please download the updated firmware from this
location, and install into the same directory as your previous version
(typically /lib/firmware).

http://www.kernellabs.com/firmware/xc5000/

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
