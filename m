Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34373 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2AKQt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 11:49:27 -0500
Received: by vcbfk14 with SMTP id fk14so641435vcb.19
        for <linux-media@vger.kernel.org>; Wed, 11 Jan 2012 08:49:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPc4S2ZXE-vveYsg5Lq1JNjnFRqM4CQCNXmcR7Lfxmcg+0Rqsg@mail.gmail.com>
References: <CAPc4S2YkA6pyz6z17N3M-XOFw8oibOz_UzgEHyxEJsF01EODFw@mail.gmail.com>
	<CAPc4S2ZXE-vveYsg5Lq1JNjnFRqM4CQCNXmcR7Lfxmcg+0Rqsg@mail.gmail.com>
Date: Wed, 11 Jan 2012 11:49:26 -0500
Message-ID: <CAGoCfiyNqR-cb1O3eTioXk2rNjOrsKGrET22rS0hbLuh_2smhw@mail.gmail.com>
Subject: Re: "cannot allocate memory" with IO_METHOD_USERPTR
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Christopher Peters <cpeters@ucmo.edu>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 11, 2012 at 11:38 AM, Christopher Peters <cpeters@ucmo.edu> wrote:
> The board is a generic saa7134-based board, and the driver has been
> forced to treat it as an "AVerMedia DVD EZMaker" (i.e. the option
> "card=33" has been passed to the module)

I wouldn't be remotely surprised if the saa7134 driver was among those
that don't support USERPTR.  I would have to look at the driver source
to confirm though.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
