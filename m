Return-path: <linux-media-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:16806 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZALGU3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2009 01:20:29 -0500
Received: by wf-out-1314.google.com with SMTP id 27so11191462wfd.4
        for <linux-media@vger.kernel.org>; Sun, 11 Jan 2009 22:20:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200811291506.11758.tobias.lorenz@gmx.net>
References: <5d5443650811282312w508c0804qf962f6cf5e859e2@mail.gmail.com>
	 <200811291506.11758.tobias.lorenz@gmx.net>
Date: Mon, 12 Jan 2009 11:50:28 +0530
Message-ID: <5d5443650901112220x12827f8fre801c7e8d23d7479@mail.gmail.com>
Subject: Re: FM transmitter support under v4l2?
From: Trilok Soni <soni.trilok@gmail.com>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tobias,

On Sat, Nov 29, 2008 at 7:36 PM, Tobias Lorenz <tobias.lorenz@gmx.net> wrote:
> Hi Trilok,
>
>> Anybody working on FM transmitter related drivers support under v4l2?
>
>> If no, what parts of v4l2 which could be tweaked in right order to
>
>> support such devices? I see that SI471x series seem to have FM
>
>> transmitters too.
>
> right, there are several Si47xx series:
>
> Si470x: receivers only
>
> Si471x: transmitter only

FYI..now maemo kernel team seems to have written Si4713 FM transmitter
driver interfaced over I2C. It is available in the kernel diff here.

http://repository.maemo.org/pool/maemo5.0/free/k/kernel/kernel_2.6.27-20084805r03.diff.gz

Please download and unzip it and search for

radio-si4713.c

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
