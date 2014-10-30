Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35740 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161047AbaJ3VJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 17:09:34 -0400
Received: by mail-oi0-f49.google.com with SMTP id u20so4633039oif.22
        for <linux-media@vger.kernel.org>; Thu, 30 Oct 2014 14:09:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEVwYfhaWMOzmvxAzV+DYn945LuA1wOSqpdvHEVpCxMW+u2afw@mail.gmail.com>
References: <CAEVwYfhaWMOzmvxAzV+DYn945LuA1wOSqpdvHEVpCxMW+u2afw@mail.gmail.com>
Date: Thu, 30 Oct 2014 22:09:33 +0100
Message-ID: <CAEVwYfgeXYp_ZdrDaxiDU7Epn+dSPjH7Bs-p=ZhMG_E-F2qN_g@mail.gmail.com>
Subject: Re: cx23885 0000:01:00.0: DVB: adapter 0 frontend 0 frequency 0 out
 of range (950000..2150000)
From: beta992 <beta992@gmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any update on DVB-C support? It seems that the patch that
ZZram made, works on lower versions, but not on the current branch.

I have looked in the media_tree.git branch, and see that the (needed)
flags are their, but still it says 'DVB-C not supported'. Would be
great if you guys could implement this.

Thanks and waiting for a replay!
