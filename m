Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:51012 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZDZPWg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 11:22:36 -0400
Received: by bwz7 with SMTP id 7so1856291bwz.37
        for <linux-media@vger.kernel.org>; Sun, 26 Apr 2009 08:22:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240749018-9043-1-git-send-email-tklauser@distanz.ch>
References: <1240749018-9043-1-git-send-email-tklauser@distanz.ch>
Date: Sun, 26 Apr 2009 17:22:34 +0200
Message-ID: <62e5edd40904260822hc47711ci8ea0c846e609f905@mail.gmail.com>
Subject: Re: [PATCH] gspca - m5602: Storage class should be before const
	qualifier
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/4/26 Tobias Klauser <tklauser@distanz.ch>:
> The C99 specification states in section 6.11.5:
>
> The placement of a storage-class specifier other than at the
> beginning of the declaration specifiers in a declaration is an
> obsolescent feature.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

I've queued a version of this patch to my repository.
Thanks!

Best regards,
Erik
