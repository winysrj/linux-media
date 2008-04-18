Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3I63ZhG020947
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 02:03:35 -0400
Received: from cnc.isely.net (cnc.isely.net [64.81.146.143])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3I63NuP020756
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 02:03:24 -0400
Date: Fri, 18 Apr 2008 01:03:17 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20080414184153.GZ6695@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0804180100180.31065@cnc.isely.net>
References: <20080414184153.GZ6695@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Video4Linux list <video4linux-list@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [2.6 patch] video/pvrusb2/pvrusb2-hdw.c cleanups
Reply-To: Mike Isely <isely@pobox.com>
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

On Mon, 14 Apr 2008, Adrian Bunk wrote:

> This patch contains the following cleanups:
> - make the following needlessly global function static:
>   - pvr2_hdw_set_cur_freq()
> - #if 0 the following unused global functions:
>   - pvr2_hdw_get_state_name()
>   - pvr2_hdw_get_debug_info_unlocked()
>   - pvr2_hdw_get_debug_info_locked()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---

FYI, I've merged this change into my local repository, and expect to 
push it back up for 2.6.26 as part of a pent-up pile of pvrusb2 changes.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
