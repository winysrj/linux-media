Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZJPRhe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 13:37:34 -0400
Message-ID: <4AD8B0A2.1090207@redhat.com>
Date: Fri, 16 Oct 2009 19:42:58 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Pablo Baena <pbaena@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Possible bug on libv4l read() emulation
References: <36be2c7a0910151500k847735dub3e1a8547f913e8c@mail.gmail.com>
In-Reply-To: <36be2c7a0910151500k847735dub3e1a8547f913e8c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/16/2009 12:00 AM, Pablo Baena wrote:
> I have a program where I use libv4l's read() emulation for simplicity.
> But with most v4l2 webcams I've tried, I get kernel panics.
>
> I have pics of the message if anyone cares to see them, I don't want
> to flood the mailing list.
>
> Basically, the names I see in the kernel panic from a uvcvideo card is:
>
> uvc_queue_next_buffer
> __bad_area_no_semaphore
> do_page_fault
>
> And a lot more.
>

A panic should never happen, no matter what libv4l does (as libv4l is 100%
userspace). Please submit a bug report with as much detail as possible to the
driver author.

Regards,

Hans
