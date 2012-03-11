Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47678 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2CKRsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 13:48:00 -0400
Received: by yenl12 with SMTP id l12so1929823yen.19
        for <linux-media@vger.kernel.org>; Sun, 11 Mar 2012 10:48:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120309004344.187af1e4@tiber>
References: <20120309004344.187af1e4@tiber>
Date: Sun, 11 Mar 2012 18:48:00 +0100
Message-ID: <CAL7owaBeup9ttxKC2pAjxLvTP18s70WMJMFPsargdJzp7taWeg@mail.gmail.com>
Subject: Re: Initial tuning data format for DVB-T2
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-media@vger.kernel.org
Cc: h@realh.co.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 9. März 2012 01:43 schrieb Tony Houghton <h@realh.co.uk>:
> Is there an official way of expressing DVB-T2 tuning data in the files
> used by the scan utility as input? Similarly to how roll-off and
> modulation type were added to the S/S2 lines. I think DVB-T2 needs a PLP
> id on top of the DVB-T parameters, is there anything else?

w_scan seems to use some kind of T2 format, I haven't seen other suggestions.

Christoph
