Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46777 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184Ab2EJGpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 May 2012 02:45:49 -0400
Received: by bkcji2 with SMTP id ji2so940444bkc.19
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 23:45:47 -0700 (PDT)
Message-ID: <4FAB6419.8060507@googlemail.com>
Date: Thu, 10 May 2012 08:45:45 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Jakob Haufe <sur5r@sur5r.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add quirk for camera of Lenovo Thinkpad X220 Tablet
References: <20120503023327.085062b7@samsa.ccchd.dn42>
In-Reply-To: <20120503023327.085062b7@samsa.ccchd.dn42>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Jakob,

Without this patch, is the image flipped in both: laptop and normal mode?

And could you please post the output of dmidecode? In the past we had 
different default behavior (flipped vs. non-flipped) for Thinkpad 
tablets with the same board / system identifiers.

Thanks,
Gregor
