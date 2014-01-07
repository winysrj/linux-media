Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:20002 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaAGSMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 13:12:30 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ100KPGMKT8480@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 13:12:29 -0500 (EST)
Date: Tue, 07 Jan 2014 16:12:23 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 18/18] libdvbv5: README updated for shared libdvbv5
Message-id: <20140107161223.61752b84@samsung.com>
In-reply-to: <1388407731-24369-18-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
 <1388407731-24369-18-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 30 Dec 2013 13:48:51 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  README        |  8 ++++----
>  README.libv4l | 12 ++++++++++++
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/README b/README
> index 0cccc00..a9f8089 100644
> --- a/README
> +++ b/README
> @@ -3,13 +3,13 @@ v4l-utils
>  
>  Linux V4L2 and DVB API utilities and v4l libraries (libv4l).
>  You can always find the latest development v4l-utils in the git repo:
> -http://git.linuxtv.org/v4l-utils.git 
> +http://git.linuxtv.org/v4l-utils.git
>  
>  
> -v4l libraries (libv4l)
> -----------------------
> +v4l libraries (libv4l, libdvbv5)
> +--------------------------------

No, libdvbv5 is not a V4L library. It is a DVB one.

>  
> -See README.lib for more information on libv4l, libv4l is released
> +See README.libv4l for more information on libv4l, libv4l is released
>  under the GNU Lesser General Public License.
>  
>  
> diff --git a/README.libv4l b/README.libv4l
> index 0be503f..7170801 100644
> --- a/README.libv4l
> +++ b/README.libv4l
> @@ -59,6 +59,18 @@ hardware can _really_ do it should use ENUM_FMT, not randomly try a bunch of
>  S_FMT's). For more details on the v4l2_ functions see libv4l2.h .
>  
>  
> +libdvbv5
> +--------
> +
> +This library provides the DVBv5 API to userspace programs. It can be used to
> +open DVB adapters, tune transponders and read PES and other data streams.
> +There are as well several parsers for DVB, ATSC, ISBT formats.
> +
> +The API is currently EXPERIMENTAL and likely to change.
> +Run configure with --enable-libdvbv5 in order to build a shared lib and
> +install the header files.

Seem OK to me, provided that this patch comes after or together one
that adds --enable-libdvbv5 to the autotools config files.

> +
> +
>  wrappers
>  --------
>  


-- 

Cheers,
Mauro
