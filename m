Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50373 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1JYIPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Oct 2011 04:15:01 -0400
Received: by gyb13 with SMTP id 13so249367gyb.19
        for <linux-media@vger.kernel.org>; Tue, 25 Oct 2011 01:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABbt3s5Lo7hNPxyK_NAmHHXTYt2WMQtSO9W907HxaU6HOpxTnw@mail.gmail.com>
References: <CABbt3s68q_jKf9bHPT8kuaB6donrAzmucJJseWNiX88qud273g@mail.gmail.com>
 <4EA66C5F.8080202@samsung.com> <CABbt3s5Lo7hNPxyK_NAmHHXTYt2WMQtSO9W907HxaU6HOpxTnw@mail.gmail.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 25 Oct 2011 01:14:41 -0700
Message-ID: <CAMm-=zB3iDPnuTU2969fEnXjKNKKiboBgAG_NZtf_h=FqFgQBg@mail.gmail.com>
Subject: Re: [PATCH] media: vb2: reset queued list on REQBUFS(0) call
To: Angela Wan <angela.j.wan@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, leiwen@marvell.com,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Angela,

On Tue, Oct 25, 2011 at 01:07, Angela Wan <angela.j.wan@gmail.com> wrote:
> Hi, Marek
>   Why not call vb2_queue_release directly in reqbufs(0) instead of
> __vb2_queue_free, which could clear queued_count as well?
>

vb2_queue_release is used to clean up streaming or fileio in progress,
neither of those can be active for reqbufs to proceed.

-- 
Best regards,
Pawel Osciak
