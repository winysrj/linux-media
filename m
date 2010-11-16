Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46913 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759246Ab0KPGYj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 01:24:39 -0500
Received: by qyk4 with SMTP id 4so379158qyk.19
        for <linux-media@vger.kernel.org>; Mon, 15 Nov 2010 22:24:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011151827.oAFIR5o4064639@smtp-vbr5.xs4all.nl>
References: <201011151827.oAFIR5o4064639@smtp-vbr5.xs4all.nl>
Date: Tue, 16 Nov 2010 08:24:38 +0200
Message-ID: <AANLkTim+5zGHKtEeLBZud+punK+bW0zrpUEuRRHZgqLF@mail.gmail.com>
Subject: Re: [cron job] v4l-dvb daily build: WARNINGS
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Nov 15, 2010 at 8:27 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Results of the daily build of v4l-dvb:
> sparse: ERRORS

There is also an build error in next, reported by Stephen Rothwell:
"The v4l-dvb tree still has its build failure, so I used the version from
next-20101112."
