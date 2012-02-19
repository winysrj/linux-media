Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.88]:40495
	"HELO nm3-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750951Ab2BSXxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 18:53:11 -0500
Message-ID: <4F4189EB.6020202@yahoo.com>
Date: Sun, 19 Feb 2012 23:46:51 +0000
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: gennarone@gmail.com, linux-media@vger.kernel.org
Subject: [PATCH] em28xx: pre-allocate DVB isoc transfer buffers
References: <1329155962-22896-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1329155962-22896-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gianluca,

One quick comment about your patch; I've noticed that you've declared two new 
"GPL only" symbols:

EXPORT_SYMBOL_GPL(em28xx_capture_start);
EXPORT_SYMBOL_GPL(em28xx_alloc_isoc);

I'm not sure what the exact policy is with GPL symbols, but I do know what Al 
Viro posted recently on the subject:

http://thread.gmane.org/gmane.linux.file-systems/61372

Do we really need EXPORT_SYMBOL_GPL() here?

Cheers,
Chris
