Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:32652 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZCaCrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 22:47:53 -0400
Received: by rv-out-0506.google.com with SMTP id f9so2761622rvb.1
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 19:47:51 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 31 Mar 2009 10:47:50 +0800
Message-ID: <15ed362e0903301947rf0de73eo8edbd8cbcd5b5abd@mail.gmail.com>
Subject: XC5000 DVB-T/DMB-TH support
From: David Wong <davidtlwong@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Does anyone know how to get XC5000 working for DVB-T, especially 8MHz bandwidth?
Current driver only supports ATSC with 6MHz bandwidth only.
It seems there is a trick at setting compensated RF frequency.

DVB-T 8MHz support would probably works for DMB-TH, but DMB-TH
settings is very welcome.

Regards,
David
