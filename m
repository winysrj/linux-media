Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:48524 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbZBWOsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 09:48:51 -0500
Received: by qyk4 with SMTP id 4so2824646qyk.13
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2009 06:48:50 -0800 (PST)
Date: Mon, 23 Feb 2009 11:48:44 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: POLL: for/against dropping support for kernels < 2.6.22
Message-ID: <20090223114844.111cd9d1@gmail.com>
In-Reply-To: <200902221115.01464.hverkuil@xs4all.nl>
References: <200902221115.01464.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Sun, 22 Feb 2009 11:15:01 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi all,
> 
> There are lot's of discussions, but it can be hard sometimes to
> actually determine someone's opinion.
> 
> So here is a quick poll, please reply either to the list or directly
> to me with your yes/no answer and (optional but welcome) a short
> explanation to your standpoint. It doesn't matter if you are a user
> or developer, I'd like to see your opinion regardless.
> 
> Please DO NOT reply to the replies, I'll summarize the results in a
> week's time and then we can discuss it further.
> 
> Should we drop support for kernels <2.6.22 in our v4l-dvb repository?
> 
> _: Yes
> _: No
> 

No

> Optional question:
> 
> Why:

I know it's not easy task keep this support working... but we
still have *users* around the world using kernel < 2.6.22 (as
some of them already reported this). 

Cheers,
Douglas
