Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:63864 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A2Qla (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:41:30 -0500
Received: by mail-qa0-f47.google.com with SMTP id j8so1722302qah.13
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2013 08:41:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
Date: Tue, 29 Jan 2013 11:41:29 -0500
Message-ID: <CAGoCfizYMTrfExhT4oeevmhUuysG6MY_CUNkzL7mY51Xjz51LQ@mail.gmail.com>
Subject: Re: [RFCv1 PATCH 00/20] cx231xx: v4l2-compliance fixes
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 29, 2013 at 11:32 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> I will take a closer look at the vbi support, though.. It would be nice to get
> that working.

FYI:  I had the VBI support working when I submitted the driver
upstream (at least for NTSC CC).  If it doesn't work, then somebody
broke it.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
