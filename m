Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49841 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2F3Pi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jun 2012 11:38:26 -0400
Received: by eaak11 with SMTP id k11so1676319eaa.19
        for <linux-media@vger.kernel.org>; Sat, 30 Jun 2012 08:38:23 -0700 (PDT)
Message-ID: <4FEF1D6D.7080603@gmail.com>
Date: Sat, 30 Jun 2012 17:38:21 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] V4L: DocBook: Corrected focus control documentation
References: <201205151320.19569.hverkuil@xs4all.nl> <1337114679-18798-1-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1337114679-18798-1-git-send-email-sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2012 10:44 PM, Sylwester Nawrocki wrote:
> Remove documentation chunk of not existent V4L2_CID_AUTO_FOCUS_AREA
> control. It fixes following build error:
>
> Error: no ID for constraint linkend: v4l2-auto-focus-area.

Ping.

This patch is still not in linux-next (and marked as "Changes requested"
in the patchwork).

Regards,
Sylwester
