Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:45060 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3HTNNX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 09:13:23 -0400
Date: Tue, 20 Aug 2013 15:13:16 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org, Yaroslav Zakharuk <slavikz@gmail.com>,
	1173723@bugs.launchpad.net, stable@vger.kernel.org
Subject: Re: [PATCH] [media] gspca-ov534: don't call sd_start() from
 sd_init()
Message-Id: <20130820151316.08617248d480ab5464ffde47@studenti.unina.it>
In-Reply-To: <52135F42.1070707@redhat.com>
References: <5205D969.4040301@gmail.com>
	<1376562572-10772-1-git-send-email-ospite@studenti.unina.it>
	<52135F42.1070707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 20 Aug 2013 14:21:22 +0200
Hans de Goede <hdegoede@redhat.com> wrote:

> Hi,
> 
> Thanks for the patch I've added this to my "gspca" tree, and this
> will be included in my next pull-request to Mauro for 3.12
> 

Thanks HdG.

It's fine with me to have the patch in 3.12 and then have it picked up
for inclusion in stable releases, I was just wondering why you didn't
consider it as a fix for 3.11, the patch fixes an actual crash
experienced by a user.

Regards,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
