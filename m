Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:52275 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3CLCFv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 22:05:51 -0400
Received: by mail-qe0-f43.google.com with SMTP id 1so2661362qee.2
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 19:05:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6d4b25c7bfc65cfff4937133bed3e60828c20174.1363035203.git.hans.verkuil@cisco.com>
References: <0e2409cf677013b9cad1ba4aee17fe434dae7146.1363035203.git.hans.verkuil@cisco.com>
	<1363035646-25244-1-git-send-email-hverkuil@xs4all.nl>
	<6d4b25c7bfc65cfff4937133bed3e60828c20174.1363035203.git.hans.verkuil@cisco.com>
Date: Mon, 11 Mar 2013 22:05:50 -0400
Message-ID: <CAGoCfiyYRwjb-+i84MrxBXaxJT=Fy7ucj02N1Lvy8n4LC0FBKw@mail.gmail.com>
Subject: Re: [REVIEW PATCH 11/15] au0828: fix disconnect sequence.
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 11, 2013 at 5:00 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The driver crashed when the device was disconnected while an application
> still had a device node open. Fixed by using the release() callback of struct
> v4l2_device.

This is all obviously good stuff.  I actually spent a couple of days
working through various disconnect scenarios, but hadn't had a chance
to do a PULL request.  I will review my tree and see if you missed any
other cases that I took care of.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
