Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58887 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaJ0MPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 08:15:31 -0400
Received: by mail-pd0-f177.google.com with SMTP id v10so5475467pde.8
        for <linux-media@vger.kernel.org>; Mon, 27 Oct 2014 05:15:30 -0700 (PDT)
Message-ID: <544E375D.5040003@gmail.com>
Date: Mon, 27 Oct 2014 21:15:25 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb-core: set default properties of ISDB-S
References: <1414324874-16417-1-git-send-email-tskd08@gmail.com> <544CE569.7060507@iki.fi> <544CF97D.80109@gmail.com> <544D2271.6050800@iki.fi>
In-Reply-To: <544D2271.6050800@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2014年10月27日 01:33, Antti Palosaari wrote:
> You should calculate bw too as tuners needs set filters according to
> used channel bw. You could calculate nominal needed be using formula:
> bandwidth = roll-off factor * symbol rate

I'll include it in the next version.
thx
--
Akihiro
