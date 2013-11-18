Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:44676 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3KRObd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Nov 2013 09:31:33 -0500
Received: by mail-vb0-f52.google.com with SMTP id f12so4774851vbg.11
        for <linux-media@vger.kernel.org>; Mon, 18 Nov 2013 06:31:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
References: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
Date: Mon, 18 Nov 2013 10:31:33 -0400
Message-ID: <CAC-25o9Z_qQ4RgEg9eS92CE62x3RuQ9xqpVaiP1ze7wNyJUyYg@mail.gmail.com>
Subject: Re: [Review Patch 0/9] si4713 usb device driver
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Dinesh Ram <dinesh.ram@cern.ch>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	d ram <dinesh.ram086@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans, Dinesh,

On Tue, Oct 15, 2013 at 11:24 AM, Dinesh Ram <dinesh.ram@cern.ch> wrote:
> Hello Eduardo,
>
> In this patch series, I have addressed the comments by you
> concerning my last patch series.
> In the resulting patches, I have corrected most of the
> style issues and adding of comments. However, some warnings
> given out by checkpatch.pl (mostly complaing about lines longer
> than 80 characters) are still there because I saw that code readibility
> suffers by breaking up those lines.
>
> Also Hans has contributed patches 8 and 9 in this patch series
> which address the issues of the handling of unknown regulators,
> which have apparently changed since 3.10. Hans has tested it and the
> driver loads again.
>
> Let me know when you are able to test it again.


After fixing the compilation issue, you can add my:


Tested-by: Eduardo Valentin <edubezval@gmail.com>
Acked-by: Eduardo Valentin <edubezval@gmail.com>

Tests were done using n900. The si4721 case needs to be taken in a
separated work I believe. So although I believe it is a minor diff, I
won't add my tested by for now on that case.

>
> Kind regards,
> Dinesh Ram
> dinesh.ram@cern.ch
> dinesh.ram086@gmail.com
>



-- 
Eduardo Bezerra Valentin
