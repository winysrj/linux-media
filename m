Return-path: <linux-media-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:47499 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab1IDVMs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Sep 2011 17:12:48 -0400
Date: Sun, 4 Sep 2011 23:12:18 +0200
From: Florian Mickler <florian@mickler.org>
To: Florian Mickler <florian@mickler.org>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	error27@gmail.com, pboettcher@kernellabs.com,
	Markus_Stephan@freenet.de, jirislaby@gmail.com
Subject: Re: [PATCH v2] [media] vp702x: fix buffer handling
Message-ID: <20110904231218.7469551d@schatten.dmk.lab>
In-Reply-To: <1314310275-30960-1-git-send-email-florian@mickler.org>
References: <1312300213-29099-1-git-send-email-florian@mickler.org>
	<1314310275-30960-1-git-send-email-florian@mickler.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 26 Aug 2011 00:11:15 +0200
Florian Mickler <florian@mickler.org> wrote:

> In my previous change to this driver, I was not aware, that dvb_usb_device_init
> calls the frontend_attach routine which needs a transfer
> buffer. So we can not setup anything private in the probe routine beforehand but
> have to allocate when needed. This means also that we cannot use a private
> buffer mutex to serialize that buffer but instead need to use the
> dvb_usb_device's usb_mutex.
> 
> Fixes: https://bugzilla.novell.com/show_bug.cgi?id=709440
> 
> Tested-by: Markus Stephan <Markus_Stephan@freenet.de>
> Signed-off-by: Florian Mickler <florian@mickler.org>
> ---
> 
> So, someone who could test that driver found me after all.
> 
> I renamed the functions to get rid of that ugly and pointless _unlocked suffix I
> deliriously added earlier. Markus tested this patch modulo function renaming. I am
> so shure that this version will still work for him, that I already added his
> Tested-by. *fingerscrossed*


Hi Mauro!
I just checked patchwork and in case you hold off on this because of my
*fingerscrossed* remark above: Markus reported off-list that this
version still works for him. 

Regards,
Flo

