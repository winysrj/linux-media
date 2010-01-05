Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:21221 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab0AESOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2010 13:14:24 -0500
Received: by fg-out-1718.google.com with SMTP id 22so6546087fge.1
        for <linux-media@vger.kernel.org>; Tue, 05 Jan 2010 10:14:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B437BFE.7040003@chello.at>
References: <4B437BFE.7040003@chello.at>
Date: Tue, 5 Jan 2010 13:14:21 -0500
Message-ID: <829197381001051014s42766227i6496437d2c557607@mail.gmail.com>
Subject: Re: PROBLEM: DVB-T scan not working after ioctl
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?B?RnJhbnogRvxyYmHf?= <franz.fuerbass@chello.at>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 5, 2010 at 12:50 PM, Franz Fürbaß <franz.fuerbass@chello.at> wrote:
> Hello,
>
> [1] . Can't scan for DVB-T channels with Hauppauge HVR 4000 HD.
>
> [2] Got a scan problem with the Hauppauge HVR 4000 HD card.
> If I try to scan for channels with the DVB-T frontend
> (/dev/dvb/adapter0/frontend1)
> no lock is generated after this sequence:
>
> -open()
> -ioctl( fd, FE_GET_INFO, &fe_info )
> -close()
> -open()
> -ioctl( fd, FE_GET_INFO, &fe_info )

Could be some sort of timing bug where the frontend kernel thread is
suspending the device.  Just as a test, try putting an "msleep(5000);"
between the first close and the second open(), and see if the problem
still occurs.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
