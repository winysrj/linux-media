Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37344 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaDYUIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 16:08:16 -0400
Received: by mail-pa0-f46.google.com with SMTP id kp14so3535772pab.19
        for <linux-media@vger.kernel.org>; Fri, 25 Apr 2014 13:08:15 -0700 (PDT)
Date: Fri, 25 Apr 2014 13:07:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Oleg Nesterov <oleg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Roland Dreier <roland@kernel.org>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Omar Ramirez Luna <omar.ramirez@copitl.com>,
	Inki Dae <inki.dae@samsung.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] mm: get_user_pages(write,force) refuse to COW in shared
 areas
In-Reply-To: <20140425190931.GA11323@redhat.com>
Message-ID: <alpine.LSU.2.11.1404251254230.6272@eggly.anvils>
References: <alpine.LSU.2.11.1404040120110.6880@eggly.anvils> <20140424133055.GA13269@redhat.com> <alpine.LSU.2.11.1404241518510.4454@eggly.anvils> <20140425190931.GA11323@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 25 Apr 2014, Oleg Nesterov wrote:
> 
> And I forgot to mention, there is another reason why I would like to
> change uprobes to follow the same convention. I still think it would
> be better to kill __replace_page() and use gup(FOLL_WRITE | FORCE)
> in uprobe_write_opcode().

Oh, please please do!  I assumed there was a good atomicity reason
for doing it that way, but if you can do it with gup() please do so.

I went off into a little rant about __replace_page() in my reply to you;
but then felt that you had approached with an honest enquiry, and didn't
deserve a rant in response, so I deleted it.

And, of course, I'm conscious that I have from start to finish withheld
my involvement from uprobes, and refused to review that __replace_page()
(beyond insisting that it not be put in a common place for sharing with
KSM, because I just couldn't guarantee it for uprobes).  I'm afraid that
it's much like HWPoison to me, a complexity (nastiness?) way beyond what
I have time to support myself.

Hugh
