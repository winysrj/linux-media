Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55312 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423369AbcFMRzp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 13:55:45 -0400
Subject: Re: LinuxTv doesn't build anymore after upgrading Ubuntu to 3.13.0-88
To: Andreas Matthies <a.matthies@gmx.net>, linux-media@vger.kernel.org
References: <575EE9D9.3030502@gmx.net>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <575EF39A.4010609@xs4all.nl>
Date: Mon, 13 Jun 2016 19:55:38 +0200
MIME-Version: 1.0
In-Reply-To: <575EE9D9.3030502@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2016 07:14 PM, Andreas Matthies wrote:
> Hi.
> 
> Seems that there's a problem in v4.6_i2c_mux.patch. After Ubuntu was 
> upgraded to 3.13.0-88 I tried to rebuild the tv drivers and get
> 
> make[2]: Entering directory `/home/andreas/Downloads/media_build/linux'
> Applying patches for kernel 3.13.0-88-generic
> patch -s -f -N -p1 -i ../backports/api_version.patch
> patch -s -f -N -p1 -i ../backports/pr_fmt.patch
> patch -s -f -N -p1 -i ../backports/debug.patch
> patch -s -f -N -p1 -i ../backports/drx39xxj.patch
> patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
> 2 out of 23 hunks FAILED
> make[2]: *** [apply_patches] Error 1

Fixed. Thanks for reporting this.

Regards,

	Hans
