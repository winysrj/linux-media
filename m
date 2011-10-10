Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([213.240.235.226]:41465 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753708Ab1JJLMO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 07:12:14 -0400
Message-ID: <4E92D0B1.1050605@mm-sol.com>
Date: Mon, 10 Oct 2011 14:02:09 +0300
From: Todor Tomov <ttomov@mm-sol.com>
MIME-Version: 1.0
To: Masaru Nomiya <nomiya@galaxy.dti.ne.jp>
CC: linux-media@vger.kernel.org
Subject: Re: make error
References: <87k48fk7tq.wl%nomiya@galaxy.dti.ne.jp>
In-Reply-To: <87k48fk7tq.wl%nomiya@galaxy.dti.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/08/2011 03:04 PM, Masaru Nomiya wrote:
> Hello,
>
> I tried to compile the very latest git of v4l-utils.
> But, I got an error;
>
> [...]
> g++ -m64 -o qv4l2 qv4l2.o general-tab.o ctrl-tab.o v4l2-api.o capture-win.o moc_qv4l2.o moc_general-tab.o moc_capture-win.o qrc_qv4l2.o    -L/usr/lib64 -L../../lib/libv4l2 -lv4l2 -L../../lib/libv4lconvert -lv4lconvert -lrt -L../libv4l2util -lv4l2util -ldl -ljpeg -lQtGui -L/usr/lib64 -L/usr/X11R6/lib64 -lQtCore -lpthread
> qv4l2.o: In function `ApplicationWindow::setDevice(QString const&, bool)':
> /tmp/source/v4l-utils/utils/qv4l2/qv4l2.cpp:156: undefined reference to `libv4l2_default_dev_ops'
> collect2: ld returned 1 exit status
>
> Any hint?

This is discussed here:
http://www.spinics.net/lists/linux-media/msg38924.html

> Thanks in advance.
>
> PS. My system
>
> 1. OS : openSUSE 11.3
>          3.0.6-1.1-default #1 SMP x86_64 GNU/Linux
>
> 2. gcc : gcc (SUSE Linux) 4.5.3 20110428 [gcc-4_5-branch revision 173117]
> 3. ld  : GNU ld (GNU Binutils; devel:gcc / openSUSE_11.3) 2.21.1
>
> Regards,
>
> ---
> ┏━━┓彡 Masaru Nomiya             mail-to: nomiya @ galaxy.dti.ne.jp
> ┃＼／彡
> ┗━━┛ "Bill! You married with Computers.
>            Not with Me!"
>           "No..., with money."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Best regards,
Todor Tomov

