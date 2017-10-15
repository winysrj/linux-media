Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:33234 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbdJONvQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 09:51:16 -0400
Subject: Re: [PATCH] media: dvb_ca_en50221: sanity check slot number from
 userspace
To: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ralph Metzler <rjkm@metzlerbros.de>,
        linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170920221959.5979-1-colin.king@canonical.com>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <70193c32-abed-aaac-f827-1588d203e8cd@anw.at>
Date: Sun, 15 Oct 2017 15:51:07 +0200
MIME-Version: 1.0
In-Reply-To: <20170920221959.5979-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Good catch!

> Seems that this bug has been in the driver forever.
Indeed ... and I overlooked it during my recent changes to that module.

Reviewed-by: Jasmin Jessich <jasmin@anw.at>

BR,
   Jasmin
