Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBJ4cOMD028980
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 23:38:24 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBJ4cBP9020650
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 23:38:11 -0500
Received: by wf-out-1314.google.com with SMTP id 25so794817wfc.6
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 20:38:11 -0800 (PST)
Message-ID: <aec7e5c30812182038v5d89c2bnfc2a71ebd61783b@mail.gmail.com>
Date: Fri, 19 Dec 2008 13:38:10 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0812181613050.5510@axis700.grange>
Cc: Magnus Damm <damm@igel.co.jp>, video4linux-list@redhat.com,
	Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: A patch got applied to v4l bypassing v4l lists
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Guennadi,

On Fri, Dec 19, 2008 at 12:23 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> just stumbled upon a patch
>
> sh: sh_mobile ceu clock framework support
>
> that has been pulled through linux-sh ML and the sh tree without even
> being cc-ed to the v4l list, which wasn't a very good idea IMHO. Now this
> patch has to be manually "back-ported" to v4l hg repos using the
> "kernel-sync:" tag and only in part, because arch/sh directory is not in
> hg at all. Can we please avoid this in the future?

That specific patch set improved clock framework support and changed
quite a few SuperH drivers. I should have CC-ed you. Sorry about that,
will do next time.

/ magnus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
