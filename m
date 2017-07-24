Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:36795 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753958AbdGXVFG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 17:05:06 -0400
Subject: Re: [PATCH 2/3] build: Disable VIDEO_OV5670 for Kernels older that
 3.17
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net
References: <1500811924-4559-1-git-send-email-jasmin@anw.at>
 <1500811924-4559-3-git-send-email-jasmin@anw.at>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <6d267fcc-2bfd-5c9f-ffd2-16ec45e4a984@anw.at>
Date: Mon, 24 Jul 2017 23:05:01 +0200
MIME-Version: 1.0
In-Reply-To: <1500811924-4559-3-git-send-email-jasmin@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Superseded by:
 [PATCH V2 2/3] build: CEC_PIN and the VIDEO_OV5670 driver both require kernel 4.10 to compile

So please drop this patch.

BR,
   Jasmin
