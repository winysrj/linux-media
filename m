Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35101 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbbLORVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 12:21:19 -0500
Received: by mail-io0-f178.google.com with SMTP id q126so26849546iof.2
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2015 09:21:18 -0800 (PST)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com. [209.85.223.170])
        by smtp.gmail.com with ESMTPSA id wa7sm1371004igb.2.2015.12.15.09.21.16
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 15 Dec 2015 09:21:16 -0800 (PST)
Received: by mail-io0-f170.google.com with SMTP id q126so26848184iof.2
        for <linux-media@vger.kernel.org>; Tue, 15 Dec 2015 09:21:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56701A99.3000404@imgtec.com>
References: <20151215012955.GA28277@dtor-ws>
	<20151215133020.GD883@joana>
	<56701A99.3000404@imgtec.com>
Date: Tue, 15 Dec 2015 09:21:15 -0800
Message-ID: <CAE_wzQ_KsfDqFt7pxXjA_STcd76C6KxhWMB5ZGo+6v_TeBmcUQ@mail.gmail.com>
Subject: Re: [PATCH] android: fix warning when releasing active sync point
From: Dmitry Torokhov <dtor@chromium.org>
To: Frank Binns <frank.binns@imgtec.com>
Cc: Gustavo Padovan <gustavo@padovan.org>,
	Dmitry Torokhov <dtor@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Andrew Bresticker <abrestic@chromium.org>,
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
	dri-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Riley Andrews <riandrews@android.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 15, 2015 at 5:50 AM, Frank Binns <frank.binns@imgtec.com> wrote:
> Is this not the issue fixed by 8e43c9c75?

No because if we start teardown without waiting for the fence to be
signaled it will still be on the active_list.

Thanks.

-- 
Dmitry
