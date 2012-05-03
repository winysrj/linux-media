Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37282 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2ECP46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2012 11:56:58 -0400
Received: by eaaq12 with SMTP id q12so569642eaa.19
        for <linux-media@vger.kernel.org>; Thu, 03 May 2012 08:56:57 -0700 (PDT)
Date: Thu, 3 May 2012 17:56:53 +0200
From: Domenico Andreoli <cavokz@gmail.com>
To: Teun <tk@tkteun.tweak.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: Error compiling tw68-v2 module (module_param / linux3.2)
Message-ID: <20120503155653.GA3431@glitch>
References: <4FA14574.5040603@tkteun.tweak.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA14574.5040603@tkteun.tweak.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, May 02, 2012 at 04:32:20PM +0200, Teun wrote:
> I'm having problems compiling the tw68-v2. I looked up the code from
> the error messages, but I don't know anything about making linux
> driver modules.
> I can't find a lot about the module_param function, at least, not
> why this would be wrong.
> 
> Can anyone give any comment on this?

yep, you are missing header linux/module.h. please pull again from gitorious.

> Thanks in advance!

no, thank you ;)

cheers,
Domenico
