Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53821 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab0JPSlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Oct 2010 14:41:04 -0400
Received: by iwn35 with SMTP id 35so2205640iwn.19
        for <linux-media@vger.kernel.org>; Sat, 16 Oct 2010 11:41:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimM9f-nOeH+Kn759dc_md4PQgyB7tkHz0d7hNY3@mail.gmail.com>
References: <4CB753F2.7080009@gmail.com>
	<4CB9B8CF.1060503@gmail.com>
	<AANLkTimM9f-nOeH+Kn759dc_md4PQgyB7tkHz0d7hNY3@mail.gmail.com>
Date: Sat, 16 Oct 2010 10:32:40 -0700
Message-ID: <AANLkTikgafJNZ+kU4ne3_gj6Pb6bWZnLQ6CY+k0XZn9_@mail.gmail.com>
Subject: Re: [PATCH] gp8psk: Add support for the Genpix Skywalker-2
From: VDR User <user.vdr@gmail.com>
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
Cc: linux-media@vger.kernel.org, alannisota@gmail.com
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Seems some #if 0 code is gone from git and that's the reason.  I made
a new patch against git and resubmitted.  Is it git behavior to remove
#if 0 code, or did someone do it?  I couldn't find any log of any
patch that removed it in git.

Thanks,
Derek
