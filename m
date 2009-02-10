Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:45863 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZBJJUY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Feb 2009 04:20:24 -0500
Received: by bwz5 with SMTP id 5so2377338bwz.13
        for <linux-media@vger.kernel.org>; Tue, 10 Feb 2009 01:20:22 -0800 (PST)
Message-ID: <499146D4.8090702@gmail.com>
Date: Tue, 10 Feb 2009 10:20:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: hvaibhav@ti.com, mchehab@redhat.com
CC: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] v4l/tvp514x: try_count reaches 0, not -1
References: <4990A6B2.1080902@gmail.com>
In-Reply-To: <4990A6B2.1080902@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Roel Kluin wrote:
> with while (try_count-- > 0) { ... } try_count reaches 0, not -1.

Sorry but this is bogus, please ignore.
