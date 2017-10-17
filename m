Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:46835 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762867AbdJQO17 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 10:27:59 -0400
Received: by mail-oi0-f67.google.com with SMTP id n82so3234929oig.3
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 07:27:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171017135324.GM20805@n2100.armlinux.org.uk>
References: <m3fuail25k.fsf@t19.piap.pl> <CAOMZO5A6PYfXz6T4ZTs7M3rtUZLKOjf636i-v6uCjxNfxETQyQ@mail.gmail.com>
 <m3376hlxc4.fsf@t19.piap.pl> <20171017135324.GM20805@n2100.armlinux.org.uk>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 17 Oct 2017 12:27:58 -0200
Message-ID: <CAOMZO5CmQR9r3J+8tMbh7YjGi323SSnX4Oz3cDgj3O2bkiZ9vA@mail.gmail.com>
Subject: Re: [PATCH][MEDIA]i.MX6 CSI: Fix MIPI camera operation in RAW/Bayer mode
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 17, 2017 at 11:53 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:

> I do wish the patch was merged (which fixes a real problem) rather than
> hanging around for optimisation questions.  We can always increase it
> in the future if it's deemed that a larger burst size is beneficial.

Agreed.
