Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60095 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758794Ab2CTAKA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 20:10:00 -0400
Received: by yenl12 with SMTP id l12so5945788yen.19
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2012 17:10:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABA=pqfbzWV45e7RLVTzrnnr4LCDwQD2d3kdYw0hcehSo3VCuQ@mail.gmail.com>
References: <CABA=pqfbzWV45e7RLVTzrnnr4LCDwQD2d3kdYw0hcehSo3VCuQ@mail.gmail.com>
Date: Tue, 20 Mar 2012 02:10:00 +0200
Message-ID: <CABA=pqdnKHnrvt-RZpvYfZsSAWzBM2oynzxXer9xXr94Ynyjqg@mail.gmail.com>
Subject: Re: [PATCH] em28xx: support for 2304:0242 PCTV QuatroStick (510e)
From: Ivan Kalvachev <ikalvachev@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hardware is based of:
Empia EM2884
Micronas DRX 3926K
NXP TDA18271HDC2
AVF4910 (not used atm)

This model is almost identical to the PCTV 520e.
There is no LED on it and the drx-k may be spin A1, A2 or A3.

Signed-off-by: Ivan Kalvachev <ikalvachev@gmail.com>
