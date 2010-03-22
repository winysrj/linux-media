Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:58057 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0CVTey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Mar 2010 15:34:54 -0400
Received: by ewy8 with SMTP id 8so350726ewy.28
        for <linux-media@vger.kernel.org>; Mon, 22 Mar 2010 12:34:52 -0700 (PDT)
Message-ID: <4BA7C651.50809@googlemail.com>
Date: Mon, 22 Mar 2010 20:34:41 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: av7110 and budget_av are broken!
References: <4B8E4A6F.2050809@googlemail.com> <201003201520.40069.hverkuil@xs4all.nl> <4BA4F1B5.80500@googlemail.com> <201003202237.23174.hverkuil@xs4all.nl>
In-Reply-To: <201003202237.23174.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.3.2010 22:37, schrieb Hans Verkuil:
> On Saturday 20 March 2010 17:03:01 e9hack wrote:
> OK, I know that. But does the patch I mailed you last time fix this problem
> without causing new ones? If so, then I'll post that patch to the list.

With your last patch, I've no problems. I'm using a a TT-C2300 and a Budget card. If my
VDR does start, currently I've no chance to determine which module is load first, but it
works. If I unload all modules and load it again, I've no problem. In this case, the
modules for the budget card is load first and the modules for the FF loads as second one.

Regards,
Hartmut
