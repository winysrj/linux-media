Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:53446 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750769AbdIWOBK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 10:01:10 -0400
Subject: Re: [git:media_tree/master] media: dvb-frontends: delete jump targets
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <E1dvjhN-0000Od-Mr@www.linuxtv.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
Message-ID: <a26207b5-2390-a6f0-a1c6-9ed29ca3f9ae@users.sourceforge.net>
Date: Sat, 23 Sep 2017 16:01:01 +0200
MIME-Version: 1.0
In-Reply-To: <E1dvjhN-0000Od-Mr@www.linuxtv.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> * Return directly after a call of the function "kzalloc" failed

Is this wording still appropriate in the commit description for such a combination
of changes for 4 source files?

Regards,
Markus


…
>  	buf = kmalloc(len + 1, GFP_KERNEL);
> -	if (buf == NULL) {
…
