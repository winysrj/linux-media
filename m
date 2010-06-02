Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758632Ab0FBVJy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Jun 2010 17:09:54 -0400
Date: Wed, 2 Jun 2010 14:09:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [Bugme-new] [Bug 16077] New: Drop is video frame rate in kernel
 .34
Message-Id: <20100602140916.759d7159.akpm@linux-foundation.org>
In-Reply-To: <bug-16077-10286@https.bugzilla.kernel.org/>
References: <bug-16077-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 30 May 2010 14:29:55 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=16077

2.6.33 -> 2.6.34 performance regression in dvb webcam frame rates.
