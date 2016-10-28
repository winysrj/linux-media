Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpoutz28.laposte.net ([194.117.213.103]:56351 "EHLO
        smtp.laposte.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936553AbcJ1HxB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 03:53:01 -0400
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout016 (Postfix) with ESMTP id 3767A113EEE
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 09:52:59 +0200 (CEST)
Received: from smtp.laposte.net (localhost [127.0.0.1])
        by lpn-prd-vrout016 (Postfix) with ESMTP id A97A211423E
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 09:52:55 +0200 (CEST)
Received: from lpn-prd-vrin002 (lpn-prd-vrin002.prosodie [10.128.63.3])
        by lpn-prd-vrout016 (Postfix) with ESMTP id A7508113E6D
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 09:52:55 +0200 (CEST)
Received: from lpn-prd-vrin002 (localhost [127.0.0.1])
        by lpn-prd-vrin002 (Postfix) with ESMTP id 8DD0A5BF22D
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 09:52:55 +0200 (CEST)
Date: Fri, 28 Oct 2016 09:52:54 +0200
From: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH next 1/2] media: mtk-mdp: fix video_device_release
 argument
Message-ID: <20161028075253.gdy2bbugih6oqncw@romuald.bergerie>
References: <1473340146-6598-4-git-send-email-minghsiu.tsai@mediatek.com>
 <20161027202325.20680-1-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161027202325.20680-1-vincent.stehle@laposte.net>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 27, 2016 at 10:23:24PM +0200, Vincent Stehlé wrote:
> video_device_release() takes a pointer to struct video_device as argument.
> Fix two call sites where the address of the pointer is passed instead.

Sorry, I messed up: please ignore that "fix". The 0day robot made me
realize this is indeed not a proper fix.

The issue remains, though: we cannot call video_device_release() on the
vdev structure member, as this will in turn call kfree(). Most probably,
vdev needs to be dynamically allocated, or the call to
video_device_release() dropped completely.

Sorry for the bad patch.

Best regards,

Vincent.
