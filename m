Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARHgwfr005123
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 12:42:58 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.175])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mARHgel2019027
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 12:42:40 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1048582wfc.6
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 09:42:39 -0800 (PST)
Message-ID: <5d5443650811270942n2421ea27v194e4c8aa1933dda@mail.gmail.com>
Date: Thu, 27 Nov 2008 23:12:39 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Sakari Ailus" <sakari.ailus@nokia.com>
In-Reply-To: <492E69C9.9080904@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650811261044w30748b75w5a47ce8b04680f79@mail.gmail.com>
	<200811262116.42364.hverkuil@xs4all.nl>
	<5d5443650811262323l759d8c02s835c9a7454508b85@mail.gmail.com>
	<492E69C9.9080904@nokia.com>
Cc: video4linux-list@redhat.com,
	"linux-omap@vger.kernel.org Mailing List" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] Add OMAP2 camera driver
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

Hi Sakari,

>
> It *might* be possible that the same camera block would be used in non-OMAP
> CPUs as well but I guess it is safe to assume that it depends on ARCH_OMAP
> now.

Right, better to keep ARCH_OMAP as dependancy.

>>
>> Thanks for the review comments. I will resubmit the patch.
>
> Is this exactly the same code that was removed from linux-omap a while ago?
>
> ---
> commit ebdae9abf598ae8a3ee1c8c477138f82b40e7809
> Author: Tony Lindgren <tony@atomide.com>
> Date:   Mon Oct 27 13:33:13 2008 -0700
>
>    REMOVE OMAP LEGACY CODE: Delete all old omap specific v4l drivers
>
>    All v4l development must be done on the v4l mailing list with linux-omap
>    list cc'd.
>
>    Signed-off-by: Tony Lindgren <tony@atomide.com>
>

Yes, it the same commit from which I have based this patch.

> ---
>
> Although I haven't had time to discuss this anywhere, I though a possible
> reason of for the removal was that some parts of the code are not that
> pretty (e.g. DMA) and those parts should be rewritten.
>
> But yes, the OMAP 2 camera driver does actually work and I would suppose it
> has users, too (think N800/N810).

Yes, I have both ;)

>
> I'm in if the aim is to get this back to linux-omap. :-) (Waiting for the
> next patch from Trilok.)

It will come down to linux-omap via mainline tree :)

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
