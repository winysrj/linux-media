Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout.aon.at ([195.3.96.113]:64467 "EHLO smtpout.aon.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbbHaREB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 13:04:01 -0400
Message-ID: <55E488FF.3040608@a1.net>
Date: Mon, 31 Aug 2015 19:03:59 +0200
From: Johann Klammer <klammerj@a1.net>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>, linux-media@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH] media: dvb-core: Don't force CAN_INVERSION_AUTO in oneshot
 mode.
References: <1441012425-25050-1-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1441012425-25050-1-git-send-email-tvboxspy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Why not just remove the line?
	info->caps |= FE_CAN_INVERSION_AUTO;

The capabilities call interacting with the oneshot setting is rather weird and maybe unexpected.


