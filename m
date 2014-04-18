Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:39632 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaDRFor (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 01:44:47 -0400
Received: by mail-ve0-f170.google.com with SMTP id pa12so2083867veb.15
        for <linux-media@vger.kernel.org>; Thu, 17 Apr 2014 22:44:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl>
References: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 18 Apr 2014 11:14:16 +0530
Message-ID: <CA+V-a8ueM2TQw-i4Lm9SZcyCp+prWiES5LQcRckbS=_mVDtVew@mail.gmail.com>
Subject: Re: [PATCHv4 0/3] vb2: stop_streaming should return void
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, Apr 17, 2014 at 2:51 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Split off the removal of the vb2_is_streaming check as requested.
> Note that the davinci drivers still have this unnecessary check, but
> Prabhakar will remove that himself.
>
Yes will post the patch, doping the check for davinci drivers.

Thanks,
--Prabhakar
