Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483Ab0BTSx3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2010 13:53:29 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1KIrS3Z015027
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 20 Feb 2010 13:53:28 -0500
Message-ID: <4B802FCB.70003@hhs.nl>
Date: Sat, 20 Feb 2010 19:54:03 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: video4linux-list@redhat.com
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ibv4l2: error requesting 4 buffers: Device or resource busy
References: <4B7FF5FC.1090403@gmail.com> <4B7FF69D.1080608@gmail.com>
In-Reply-To: <4B7FF69D.1080608@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/20/2010 03:50 PM, Guilherme wrote:
> Guilherme wrote:
> Hi all!
>
> As I tried to migrate an applications that I had it working in another
> computer, I struggled to have it working here.
> It is a video capture application.
> The following error occurred:
>
> libv4l2: error requesting 4 buffers: Device or resource busy
> read error 16, Device or resource busy
> Press [Enter] to close the terminal ...
>
> The code is attached to this e-mail, plz can I get some help from here.
> Thanks a lot
>
> P.S. My webcam works just fine on amsn.. so I guess its not a hardware
> dependant issue... Looking online for help, people say that the drive
> might be in use something related to this that is not my case.
>

Hi,

First of all, this list is no longer in active use, linux-media (in the CC now)
is the correct list to use.

The problem you are seeing is caused by the app first doing a select() on the fd
before it does anything else which signals the driver what kind of IO the app
(mmap or read) is going to use. At this point the driver has to decide
which kind of IO it will use, as it needs to setup its internal buffers to
handle the select. when this happens, it assumes the app will use read() IO.

Then it does a read() call, which libv4l tries to emulate using mmap (for drivers
which don't implement read() themselves, and because using mmap is faster when
libv4l needs to do conversion). This fails, as libv4l cannot allocate the buffers
as the driver has already allocated buffers internally for read() based IO.

The current libv4l releasE: 0.6.4 has a fix for this.

Regards,

Hans
