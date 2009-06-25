Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:38145 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbZFYPDG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2009 11:03:06 -0400
Received: by gxk22 with SMTP id 22so845285gxk.13
        for <linux-media@vger.kernel.org>; Thu, 25 Jun 2009 08:03:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL103-W528F8A33AD6A34779DB71888340@phx.gbl>
References: <36839.62.70.2.252.1245937439.squirrel@webmail.xs4all.nl>
	 <829197380906250700s3f96262bhad95e9a758e88d3f@mail.gmail.com>
	 <COL103-W2753C79E5C866460426A1888340@phx.gbl>
	 <829197380906250738x36483ee3sb747019a4d1f23c4@mail.gmail.com>
	 <COL103-W528F8A33AD6A34779DB71888340@phx.gbl>
Date: Thu, 25 Jun 2009 11:03:07 -0400
Message-ID: <829197380906250803j6dc2b138r1febf850febf5c50@mail.gmail.com>
Subject: Re: [PARTIALLY SOLVED] Can't use my Pinnacle PCTV HD Pro stick - what
	am I doing wrong?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: George Adams <g_adams27@hotmail.com>
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 25, 2009 at 10:59 AM, George Adams<g_adams27@hotmail.com> wrote:
> Surely there must be some command-line way to change the Pinnacle device to
> channel 3 before I launch Helix Producer?

v4lctl setchannel 3

Or you might want to consider using the composite or s-video input if
that's available to you (the quality will be better).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
