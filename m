Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60351 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0JMNqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Oct 2010 09:46:36 -0400
Received: by fxm4 with SMTP id 4so1608488fxm.19
        for <linux-media@vger.kernel.org>; Wed, 13 Oct 2010 06:46:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010111741.13010.hverkuil@xs4all.nl>
References: <201010111741.13010.hverkuil@xs4all.nl>
Date: Wed, 13 Oct 2010 09:46:33 -0400
Message-ID: <AANLkTinsUyzWHvcHkFDbF=vfT2S4Pqdiir3-8RHQaWCp@mail.gmail.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Fix locking order in radio-mr800
From: David Ellingsworth <david@identd.dyndns.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Oct 11, 2010 at 11:41 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> The following changes since commit 9147e3dbca0712a5435cd2ea7c48d39344f904eb:
>  Mauro Carvalho Chehab (1):
>        V4L/DVB: cx231xx: use core-assisted lock
>
> are available in the git repository at:
>
>  ssh://linuxtv.org/git/hverkuil/v4l-dvb.git mr800
>
> Hans Verkuil (1):
>      radio-mr800: fix locking order
>

Acked-By: David Ellingsworth <david@identd.dyndns.org>
