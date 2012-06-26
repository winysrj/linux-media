Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44996 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab2FZSll (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 14:41:41 -0400
Received: by pbbrp8 with SMTP id rp8so433602pbb.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 11:41:40 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 02:41:40 +0800
Message-ID: <CAHPEttnCbmz_kY_B0HnVxo4WjCgm-uWhDDC+6TW2f-TSArGVeg@mail.gmail.com>
Subject: RE: DiBcom adapter problems
From: Choi Wing Chan <chanchoiwing@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

no, it is not related to the dibcom, but i have similar problem about
the delivery system for my dmb-th card. i apply your patch and i can
go a small step further. now i have the xc5000 error. it is because in
the xc5000 driver, the set-params function is missing a switch-case
for SYS_DMBTH. after adding the case, i still got an error in the
driver. but that is another story.

-- 
http://chanchoiwing.blogspot.com
