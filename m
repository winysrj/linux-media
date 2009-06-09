Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.150]:22770 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZFIWj3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Jun 2009 18:39:29 -0400
Received: by ey-out-1920.google.com with SMTP id 5so17582eyb.56
        for <linux-media@vger.kernel.org>; Tue, 09 Jun 2009 15:39:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A293B89.30502@iki.fi>
References: <4A28CEAD.9000000@gmail.com> <4A293B89.30502@iki.fi>
Date: Wed, 10 Jun 2009 00:39:31 +0200
Message-ID: <c4bc83220906091539x51ec2931i9260e36363784728@mail.gmail.com>
Subject: Re: AVerTV Volar Black HD: i2c oops in warm state on mips
From: Jan Nikitenko <jan.nikitenko@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Solved with "[PATCH] af9015: fix stack corruption bug".

Best regards,
Jan
