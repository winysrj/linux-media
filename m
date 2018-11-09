Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.anw.at ([195.234.102.72]:39200 "EHLO smtp.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbeKJHXM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 02:23:12 -0500
Subject: Re: [PATCH] media: Use wait_queue_head_t for media_request
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab+samsung@kernel.org
References: <20181109210605.12848-1-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <8f60cd6f-e724-6b7e-425b-57fed3b569f5@anw.at>
Date: Fri, 9 Nov 2018 22:40:34 +0100
MIME-Version: 1.0
In-Reply-To: <20181109210605.12848-1-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Temporary add this patch to media-build until it is integrated in mainline.
This should fix the build errors for Kernels older than 4.12.

BR,
   Jasmin
