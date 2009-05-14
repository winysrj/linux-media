Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:30452 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578AbZENW4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 May 2009 18:56:16 -0400
Received: by fg-out-1718.google.com with SMTP id d23so11711fga.17
        for <linux-media@vger.kernel.org>; Thu, 14 May 2009 15:56:16 -0700 (PDT)
Message-ID: <4A0CA18B.8010302@googlemail.com>
Date: Fri, 15 May 2009 00:56:11 +0200
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: BUG in av7110_vbi_write()
References: <4A0B414D.5000106@googlemail.com> <200905141344.15927@orion.escape-edv.de>
In-Reply-To: <200905141344.15927@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Endriss schrieb:
> copy_from_user() will only be called if count == sizeof d.

Ooops, I didn't see that.

Regards,
Hartmut
