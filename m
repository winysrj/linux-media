Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:57977 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3ADVEl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:04:41 -0500
Received: by mail-qc0-f178.google.com with SMTP id j34so9003159qco.37
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:04:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Date: Fri, 4 Jan 2013 16:04:40 -0500
Message-ID: <CAGoCfiync0hKdm6-RMBvyhJ32M76Nbn7qdBq8a7sgF1wo9YK5A@mail.gmail.com>
Subject: Re: [PATCH 00/15] em28xx VBI2 port and v4l2-compliance fixes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 4, 2013 at 3:59 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> This patch series converts the em28xx driver to videobuf2 and fixes
> a number of issues found with v4l2-compliance on em28xx.

There was a typo on my part.  It's VB2 (videobuf2), not VBI2.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
