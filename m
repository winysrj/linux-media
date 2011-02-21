Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62392 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BULFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 06:05:52 -0500
MIME-Version: 1.0
In-Reply-To: <1298283649-24532-2-git-send-email-dacohen@gmail.com>
References: <1298283649-24532-1-git-send-email-dacohen@gmail.com>
	<1298283649-24532-2-git-send-email-dacohen@gmail.com>
Date: Mon, 21 Feb 2011 13:05:51 +0200
Message-ID: <AANLkTimwvgLvpvndCqcd_okA2Kk4cu7z4bD3QXTdgWJW@mail.gmail.com>
Subject: Re: [PATCH 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Cohen <dacohen@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 21, 2011 at 12:20 PM, David Cohen <dacohen@gmail.com> wrote:
> Currently sched.h and wait.h have circular dependency between both.
> wait.h defines macros wake_up*() which use macros TASK_* defined by
> sched.h. But as sched.h indirectly includes wait.h, such wait.h header
> file can't include sched.h too. The side effect is when some file
> includes wait.h and tries to use its wake_up*() macros, it's necessary
> to include sched.h also.
> This patch moves all TASK_* macros from linux/sched.h to a new header
> file linux/task_sched.h. This way, both sched.h and wait.h can include
> task_sched.h and fix the circular dependency. No need to include sched.h
> anymore when wake_up*() macros are used.

Just include <linux/sched.h> in your driver.
This include splitting in small pieces is troublesome as well.

Why are you moving TASK_COMM_LEN?

> �include/linux/sched.h � � �| � 61 +-----------------------------------------
> �include/linux/task_sched.h | � 64 ++++++++++++++++++++++++++++++++++++++++++++
> �include/linux/wait.h � � � | � �1 +
> �3 files changed, 66 insertions(+), 60 deletions(-)
> �create mode 100644 include/linux/task_sched.h

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> +#include <linux/task_sched.h>
