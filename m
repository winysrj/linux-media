Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:64251 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab3JORhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Oct 2013 13:37:06 -0400
Received: by mail-la0-f41.google.com with SMTP id ec20so7378105lab.28
        for <linux-media@vger.kernel.org>; Tue, 15 Oct 2013 10:37:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
References: <1381850685-26162-1-git-send-email-dinesh.ram@cern.ch>
Date: Tue, 15 Oct 2013 13:37:04 -0400
Message-ID: <CAC-25o8idLQUjQd9JK-n13bJdOH2riSakfP8GzMqXr=D8NV9CQ@mail.gmail.com>
Subject: Re: [Review Patch 0/9] si4713 usb device driver
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Dinesh Ram <dinesh.ram@cern.ch>
Cc: Linux-Media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, dinesh.ram086@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Dinesh,

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
>

Hopefully I will be able to give it a shot on n900 and on silabs
devboard until the end of the week. Thanks for not giving up.

> Kind regards,
> Dinesh Ram
> dinesh.ram@cern.ch
> dinesh.ram086@gmail.com
>



-- 
Eduardo Bezerra Valentin
