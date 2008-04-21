Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3LMcCAx024077
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 18:38:12 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.188])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3LMbg4o005485
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 18:37:59 -0400
Received: by rn-out-0910.google.com with SMTP id e11so655508rng.7
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 15:37:59 -0700 (PDT)
Date: Mon, 21 Apr 2008 15:37:51 -0700
From: Brandon Philips <brandon@ifup.org>
To: Gregor Jasny <jasny@vidsoft.de>
Message-ID: <20080421223751.GD9073@plankton.ifup.org>
References: <20080421081639.GE26724@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421081639.GE26724@vidsoft.de>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.25 regression: vivi - scheduling while atomic
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

On 10:16 Mon 21 Apr 2008, Gregor Jasny wrote:
> Call Trace:
>  [<ffffffff803efc9b>] schedule+0xe5/0x5c7
>  [<ffffffff80251c90>] __rmqueue_smallest+0x88/0x107
>  [<ffffffff8023e84b>] getnstimeofday+0x2f/0x83
>  [<ffffffff8023cf8a>] ktime_get_ts+0x17/0x48
>  [<ffffffff803f0424>] schedule_timeout+0x1e/0xad
>  [<ffffffff80220498>] enqueue_task+0x13/0x1e
>  [<ffffffff803efab8>] wait_for_common+0xf6/0x16b
>  [<ffffffff802230a0>] default_wake_function+0x0/0xe
>  [<ffffffff8023a270>] kthread_create+0xa3/0x108
>  [<ffffffff880d2471>] :vivi:vivi_thread+0x0/0x779
>  [<ffffffff802634cb>] remap_vmalloc_range+0xa1/0xe6
>  [<ffffffff80231242>] lock_timer_base+0x26/0x4c
>  [<ffffffff8023138e>] __mod_timer+0xb6/0xc5
>  [<ffffffff880d23fc>] :vivi:vivi_start_thread+0x54/0xc9
>  [<ffffffff88053603>] :videobuf_core:videobuf_streamon+0x6c/0xaa
>  [<ffffffff8809dba3>] :videodev:__video_do_ioctl+0x1327/0x2ad9
>  [<ffffffff80222d76>] __wake_up+0x38/0x4f
>  [<ffffffff80242f1f>] futex_wake+0xdb/0xfa
>  [<ffffffff8809f6ab>] :videodev:video_ioctl2+0x17c/0x210
>  [<ffffffff8025bb36>] handle_mm_fault+0x6b1/0x6cb
>  [<ffffffff8027b47d>] vfs_ioctl+0x55/0x6b
>  [<ffffffff8027b6e6>] do_vfs_ioctl+0x253/0x264
>  [<ffffffff8027b733>] sys_ioctl+0x3c/0x5d
>  [<ffffffff8020afcb>] system_call_after_swapgs+0x7b/0x80
>
> This happenes on a vanilla 2.6.25 with loaded nvidia graphics module.
> System architecture is x86_64. If it matters I'll try to reproduce this
> error on a non tainted kernel.

No need to reproduce on a non-tainted Kernel.  This is a known issue
with patches merged into the v4l-dvb tree several weeks ago but it seems
to not have made it into 2.6.25 :(

 http://linuxtv.org/hg/v4l-dvb/rev/06eb92ed0b18
 http://linuxtv.org/hg/v4l-dvb/rev/c50180f4ddfc

I can rebase the patches for 2.6.25 but they are too big to go into the
stable 2.6.25 tree...

Thanks for the report,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
