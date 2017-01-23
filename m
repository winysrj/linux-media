Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:36894 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750906AbdAWX1l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jan 2017 18:27:41 -0500
Received: by mail-it0-f49.google.com with SMTP id r185so78700414ita.0
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2017 15:27:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170123221335.GA10945@Belindas-MacBook-Pro.local>
References: <CAN39uTpT1W9m+_OQvP_4pbPiOPKjdTGA6tyJ9VJeGq+AZQXfuw@mail.gmail.com>
 <CAN39uTpwe0CjqmC=ajamfN8UrsarwaDZb5YRCMfTNQ2Edyph4g@mail.gmail.com> <20170123221335.GA10945@Belindas-MacBook-Pro.local>
From: VDR User <user.vdr@gmail.com>
Date: Mon, 23 Jan 2017 15:27:40 -0800
Message-ID: <CAA7C2qi3=4amVe+Uzj4WiMbE5R2xYGWtz7-eadxsupDZHCoeEw@mail.gmail.com>
Subject: Re: Mysterious regression in dvb driver
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: Dreamcat4 <dreamcat4@gmail.com>,
        "mailing list: linux-media" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just use the driver from the media_build tree and do a git bisect on
it. You can work out a bisect starting/good point from whatever kernel
version you know to be working. It shouldn't take too long to find the
offending commit.
