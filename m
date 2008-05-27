Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4RF3ptF006115
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 11:03:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4RF3SaP030925
	for <video4linux-list@redhat.com>; Tue, 27 May 2008 11:03:28 -0400
Date: Tue, 27 May 2008 12:03:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Message-ID: <20080527120303.639a5d04@gaivota>
In-Reply-To: <483BBFD1.3090204@cn.fujitsu.com>
References: <483BBFD1.3090204@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dvb-usb/gp8psk.c: return -errno rather than errno
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

On Tue, 27 May 2008 16:01:21 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> gp8psk_power_ctrl() returns -EINVAL in some failing paths, but
> returns EINVAL in some other paths.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.cn>
> ---
Thanks Li. However, I've committed a few days ago a similar patch from Marcin.


Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
