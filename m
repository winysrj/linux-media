Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34195 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2JFVeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Oct 2012 17:34:07 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2072445eek.19
        for <linux-media@vger.kernel.org>; Sat, 06 Oct 2012 14:34:04 -0700 (PDT)
Message-ID: <5070A3C9.8040409@gmail.com>
Date: Sat, 06 Oct 2012 23:34:01 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, a.hajda@samsung.com,
	sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement .get_frame_desc
 subdev callback
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com> <1348674853-24596-6-git-send-email-s.nawrocki@samsung.com> <50704D26.9020201@hoogenraad.net> <50707704.5030402@gmail.com> <50707BE0.9010209@hoogenraad.net>
In-Reply-To: <50707BE0.9010209@hoogenraad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2012 08:43 PM, Jan Hoogenraad wrote:
> Thanks.
>
> I see several drivers disabled for lower kernel versions in my Kconfig file.
> I am not sure how this is accomplished, but it would be helpful if the
> Fujitsu M-5MOLS 8MP sensor support
> is automatically disabled for kernel<  3.6
>
> I fixed it in my version by replacing SZ_1M by (1024*1024).
> I did not need the driver, but at least it compiled ...

A patch for v4l/versions.txt is needed [1].
I'll see if I can prepare that.

http://git.linuxtv.org/media_build.git/history/5d00dba6aaf0f91a742d90fd1e12e0fb2d36253e:/v4l/versions.txt 


