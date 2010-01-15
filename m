Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:64762 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab0AOM7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 07:59:32 -0500
Received: by qyk32 with SMTP id 32so437258qyk.4
        for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 04:59:31 -0800 (PST)
Message-ID: <4B5066AF.9020901@gmail.com>
Date: Fri, 15 Jan 2010 10:59:27 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: Fix for breakage caused by kfifo backport
References: <1263556855.3059.10.camel@palomino.walls.org>
In-Reply-To: <1263556855.3059.10.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andy,

On 01/15/2010 10:00 AM, Andy Walls wrote:
> Mauro,
>
> At
>
> http://linuxtv.org/hg/~awalls/cx23885-ir2
>
> I have a change checked in to fix the v4l-dvb compilation breakage for
> kernels less than 2.6.33 cause by the kfifo API change.  I have fixed
> both the cx23885 and meye driver so they compile again for older
> kernels.
>
> All the changes in this repo are OK to PULL as is, even though I haven't
> finished all the changes for the TeVii S470 IR  (I was planning on a
> PULL request late this evening EST).  You can also just cherry pick the
> one that fixes the kfifo problem if you want.
>
> [I was unaware of the timing of the backport, but since it was stopping
> me from working, I fixed it as I thought appropriate.

Ouch, I was expecting to send the pull request for these changes before.
I have created the exactly same patches. Anyway, good that we have these 
backports done.

>    Please feel free
> to contact me on any backport changes that have my fingerprints all over
> it, with which you would like help.  I'd like to help minimize the
> impact to users, testers, and developers, who may not have the bleeding
> edge kernel - or at least the impact to me ;) ]
>
>    

Cheers,
Douglas
