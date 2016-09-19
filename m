Return-path: <linux-media-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:44705 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750809AbcISGYJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 02:24:09 -0400
Subject: Re: [PATCH] Potential fix for "[BUG] process stuck when closing
 saa7146 [dvb_ttpci]"
To: Andrey Utkin <andrey_utkin@fastmail.com>,
        linux-media@vger.kernel.org
References: <20160911133317.whw3j2pok4sktkeo@pmhahn.de>
 <20160916100028.8856-1-andrey_utkin@fastmail.com>
Cc: hverkuil@xs4all.nl
From: Philipp Hahn <pmhahn+video@pmhahn.de>
Message-ID: <41790808-9100-2999-3d92-921d2076be3e@pmhahn.de>
Date: Mon, 19 Sep 2016 07:08:52 +0200
MIME-Version: 1.0
In-Reply-To: <20160916100028.8856-1-andrey_utkin@fastmail.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andrey,

Am 16.09.2016 um 12:00 schrieb Andrey Utkin:
> Please try this patch. It is purely speculative as I don't have the hardware,
> but I hope my approach is right.

Thanks you for the patch; I've built a new kernel but didn't have the
time to test it yet; I'll mail you again as soon as I have tested it.

Thanks you for looking into that issues.

Philipp
