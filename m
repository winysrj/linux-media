Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:49187 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3GaLmS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 07:42:18 -0400
Date: Wed, 31 Jul 2013 13:36:34 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Yaroslav Zakharuk <slavikz@gmail.com>
Cc: linux-media@vger.kernel.org, 1173723@bugs.launchpad.net
Subject: Re: [Regression 3.5->3.6, bisected] gspca_ov534: kernel oops when
 connecting Hercules Blog Webcam
Message-Id: <20130731133634.fbfe99f97026454593d3518f@studenti.unina.it>
In-Reply-To: <51F63305.5030503@gmail.com>
References: <51F63305.5030503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Jul 2013 12:16:53 +0300
Yaroslav Zakharuk <slavikz@gmail.com> wrote:

> Hi!
> 
> After update from 3.5 kernel to newer version I got kernel oops when I 
> connect my Hercules Blog Webcam. The full error stacktrace is at the end 
> of this e-mail.

Hi Yaroslav, I'll try to take a look this week-end.

[...]
> Additional info can be found here: 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1173723/

I saw you also tested with 3.11-rc2 kernel, and the issue is still
there: https://launchpadlibrarian.net/145608306/kern.log

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
