Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34166 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752509AbcLZQGS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Dec 2016 11:06:18 -0500
Received: by mail-qk0-f193.google.com with SMTP id t184so25956114qkd.1
        for <linux-media@vger.kernel.org>; Mon, 26 Dec 2016 08:06:18 -0800 (PST)
Received: from ?IPv6:2604:6000:130b:8061:1467:8bc7:9f82:b53? ([2604:6000:130b:8061:1467:8bc7:9f82:b53])
        by smtp.gmail.com with ESMTPSA id a69sm26478785qkj.38.2016.12.26.08.06.16
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Dec 2016 08:06:16 -0800 (PST)
To: linux-media@vger.kernel.org
From: bill murphy <gc2majortom@gmail.com>
Subject: Problem: "transfer buffer not dma capable"
Message-ID: <7616f74c-7427-511f-ee8e-4db5866e7d38@gmail.com>
Date: Mon, 26 Dec 2016 11:06:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Dec 17th Piotr Chmura reported an oops when trying to watch tv with 
his siano device, which uses smsusb, in Kaffeine.

I was recently seeing a very similar oops with Linux 4.9.0-rc6+, but 
upon plugging in a Geniatech SU30000 device (vid,pid / 0x1f4d,0x3000)

which uses dw2102. Compiling the 4.9.0-rc6+ kernel with this config 
setting disabled for now, as suggested here

https://github.com/LibreELEC/LibreELEC.tv/pull/1076 got rid of the oops 
for me, and the Geniatech device no longer experiences the

"transfer buffer not dma capable" oops. http://pastebin.com/JWdHUDac

Hope that helps someone else as it helped me.



