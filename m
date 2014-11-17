Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:44770 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKQL5s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 06:57:48 -0500
Received: by mail-ob0-f179.google.com with SMTP id va2so489092obc.24
        for <linux-media@vger.kernel.org>; Mon, 17 Nov 2014 03:57:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5447BB4B.9000001@xs4all.nl>
References: <5447BB4B.9000001@xs4all.nl>
Date: Mon, 17 Nov 2014 11:57:47 +0000
Message-ID: <CAAG0J99OzTYH=ZpJmcvRCpp_q1rgAnLNHqgO3U7_q6HvZ0Kx9w@mail.gmail.com>
Subject: Re: [REVIEW] Submitting Media Patches
From: James Hogan <james.hogan@imgtec.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22 October 2014 15:12, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> How to submit patches for a stable kernel
> =========================================
>
> The standard method is to add this tag:
>
>         Cc: stable@vger.kernel.org
>
> possibly with a comment saying to which versions it should be applied, like:
>
>         Cc: stable@vger.kernel.org      # for v3.5 and up

Maybe put angled brackets around the email address. Some versions of
git-send-email get confused by the comment otherwise and try sending
to e.g. "<stable@vger.kernel.org #3.11>".

Cheers
James
